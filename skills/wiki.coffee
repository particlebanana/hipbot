#
# wiki some stuff
#

module.exports.load = (bot) ->
  bot.desc 'wiki me PHRASE', 'returns a wikipedia page for PHRASE'
  bot.onMessage(/^@marvin wiki me (.*)$/i, wiki)


wiki = (channel, from, message, matches) ->
  self = @
  term = escape(matches[1])    
  url = "http://en.wikipedia.org/w/api.php?action=opensearch&search=#{term}&format=json"
  
  @get url, (body) ->
    try
      if body[1][0]
        self.message channel, "@" + from.split(' ')[0] + " here you are: http://en.wikipedia.org/wiki/#{escape body[1][0]}"
      else
        self.message channel, "nothin'"
    catch e
      console.log "Wiki error: " + e
