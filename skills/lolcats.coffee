#
# lol cats!
#

jsdom = require('jsdom').jsdom
sys = require 'sys'

module.exports.load = (bot) ->
  bot.desc 'lolcat me', 'returns a lolcat picture'
  bot.onMessage('@marvin lolcat me', lol)
  
  bot.desc 'failblog me', 'returns a failblog picture'
  bot.onMessage('@marvin failblog me', fail)

      
# LOLcats
lol = (channel, from, message) ->
  self = @
  url = "http://icanhascheezburger.com/?random"
  
  jsdom.env({
    html: url,
    scripts: ['http://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js'],
    done: (err, window) ->
      $ = window.jQuery
      src = $('.entry img:first').attr('src')
      if err
        self.message channel, "WTF I didn't find any LOLcats."
      else
        self.message channel, src
  })


# FAIL blog
fail = (channel, from, message) ->
  self = @
  url = "http://failblog.org/?random"

  jsdom.env({
    html: url,
    scripts: ['http://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js'],
    done: (err, window) ->
      $ = window.jQuery
      src = $('.entry img:first').attr('src')
      if err
        self.message channel, "People are smarter today. I couldn't find any FAIL."
      else
        self.message channel, src
  })