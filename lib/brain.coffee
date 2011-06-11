#
# robot brain
#

sys = require 'sys'
util = require 'util'
_ = require('underscore')
http = require 'http'
events = require 'events'
{EventEmitter} = require "events"
xmpp = require 'node-xmpp'

class exports.Brain extends process.EventEmitter
  
  constructor: (options) ->
    @setMaxListeners 0
      
    @jabber = null
    @keepalive = null
    @plugins = {}
    
    @jid = options.jid
    @password = options.password
    @name = options.name
    @debug = options.debug
    
    @descriptions = {}


  onError: (error) ->
    if error instanceof xmpp.Element
      errorMessage = 'Unknown error'

      if error.getChild('see-other-host')
        errorMessage = 'This account is signing in somewhere else. Maybe HipChat web version?'
      else
        textNode = error.getChild('text')
        if textNode
          errorMessage = textNode.getText()

      this.emit('error', errorMessage, error)
    else
      this.emit('error', error)

    @disconnect()


  enableDebug: ->
    @jabber.on('data', (buffer) ->
      console.log(' IN > ' + buffer.toString())
    )

    origSend = @jabber.send
    @jabber.send = (stanza) ->
      console.log(' OUT > ' + stanza)
      origSend.call(@jabber, stanza)


  onStanza: (stanza) ->
    @emit('data', stanza)
    
    if stanza.is('message') && stanza.attrs.type == 'groupchat'
      body = stanza.getChild('body')
      return unless body
      return if stanza.getChild('delay')

      attrFrom = stanza.attrs.from
      offset = attrFrom.indexOf('/')

      channel = attrFrom.substring(0, offset)
      from = attrFrom.substring(offset + 1)

      return if from == @name

      @emit('message', channel, from, body.getText())

    else if stanza.is('message') && stanza.attrs.type == 'chat'
      body = stanza.getChild('body')
      return unless body

      attrFrom = stanza.attrs.from
      offset = attrFrom.indexOf('/')

      jid = attrFrom.substring(0, offset)
      @emit('privateMessage', jid, body.getText())
  
  
  onOnline: ->
    self = @
    @setAvailability('chat')
    setInterval(()->
      self.emit('ping')
      self.jabber.send(' ')
    , 30000)
    @emit('connect')
  
      
  # Connect the bot and set listeners
  connect: ->
    @jabber = new xmpp.Client {
      jid: this.jid
      password: this.password
    }
    
    if @debug == true
      @enableDebug.call(this)
    
    @jabber.on('error', _.bind(@onError, @))
    @jabber.on('online', _.bind(@onOnline, @))
    @jabber.on('stanza', _.bind(@onStanza, @))
  
  
  # Update the bots availability
  setAvailability: (availability, status) ->
    packet = new xmpp.Element('presence', { type: 'available'})
    packet.c('show').t(availability)
    
    if status
      packet.c('status').t(status)
    
    @jabber.send(packet)
  
  
  # Join a room
  join: (room) ->
    packet = new xmpp.Element('presence', { to: room + '/' + @name })
    packet.c('x', { xmlns: 'http://jabber.org/protocol/muc'})
    @jabber.send(packet)
  
  
  leave: (room) ->
    packet = new xmpp.Element('presence', { type: 'unavailable', to: room + '/' + @name })
    packet.c('x', { xmlns: 'http://jabber.org/protocol/muc'})
    packet.c('status').t('hc-leave')
    @jabber.send(packet)
  
  
  # Speak Robot!
  say: (target, message, callback) ->
    @message target, message, callback
  
  # Send a message
  message: (target, message) ->
    if target.match(/^(.*)@conf.hipchat.com$/)
      packet = new xmpp.Element('message', {
        to: target + '/' + @name
        type: 'groupchat'
      })
    else
      packet = new xmpp.Element('message', {
        to: target
        type: 'chat'
        from: @jid
      })
      packet.c('inactive', { xmlns: 'http://jabber/protocol/chatstates' })
    
    packet.c('body').t(message)
    @jabber.send(packet)
      
  
  # Disconnect Bot
  disconnect: ->
    if @keepalive
      clearInterval(@keepalive)
      @keepalive = null
    
    @jabber.end()
    @emit('disconnect')
  
  
  # Send Bot on a journey
  request = (method, path, body, callback) ->    
    if match = path.match(/^(https?):\/\/([^\/]+?)(\/.+)/)
      headers = { Host: match[2],  'Content-Type': 'application/json', 'User-Agent': 'hipbot' }
      port = if match[1] == 'https' then 443 else 80
      client = http.createClient(port, match[2], port == 443)
      path = match[3]
    
    if typeof(body) is 'function' and not callback
      callback = body
      body = null
    
    if method is 'POST' and body
      body = JSON.stringify(body) if typeof(body) isnt 'string'
      headers['Content-Length'] = body.length
    
    req = client.request(method, path, headers)
        
    req.on 'response', (response) ->
      if response.statusCode is 200
        data = ''
        response.setEncoding('utf8')
        response.on 'data', (chunk) ->
          data += chunk
        response.on 'end', ->
          if callback
            try
              body = JSON.parse(data)
            catch e
              body = data
            callback body
      else if response.statusCode is 302
        request(method, path, body, callback)
      else
        console.log "#{response.statusCode}: #{path}"
        response.setEncoding('utf8')
        response.on 'data', (chunk) ->
          console.log chunk
        process.exit(1)
    
    req.write(body) if method is 'POST' and body
    req.end()

  
  #
  # robot karate skills
  #
  
  get: (path, body, callback) ->
    request('GET', path, body, callback)
  
  post: (path, body, callback) ->
    request('POST', path, body, callback)
  
  desc: (phrase, functionality) ->
    @descriptions[phrase] = functionality

  
  # Load Bot Skills
  loadPlugin: (identifier, plugin, options) ->
    @plugins[identifier] = plugin
    @plugins[identifier].load(this, options)
    true
  
  ###################
  # Events OMFG!!!!
  ###################
  
  onConnect: (callback) ->
    @on('connect', callback)
  
  
  onMessage: (condition, callback) ->
    if arguments.length == 1
      this.on('message', condition)
    
    @on('message', (channel, from, message) ->
      if typeof condition == 'string' && message == condition
        callback.apply(this, arguments)
      else if condition instanceof RegExp
        matches = message.match(condition)
        return unless matches
        
        args = Array.prototype.slice.apply(arguments)
        args.push(matches)
        callback.apply(this, args)
    )
  
  
  onPrivateMessage: (condition, callback) ->
    if arguments.length == 1
      @on('privateMessage', condition)
    
    @on('privateMessage', (from, message) ->
      if typeof condition == 'string' && message == condition
        callback.apply(this, arguments)
      else if condition instanceof RegExp
        matches = message.match(condition)
        return unless matches
        
        args = Array.prototype.slice.apply(arguments)
        args.push(matches)
        callback.apply(this, args)
    )
  
  
  onPing: (callback) ->
    @on('ping', callback)
  
  
  onError: (callback) ->
    @on('error', callback)
  
  
  onDisconnect: (callback) ->
    @on('disconnect', callback)
