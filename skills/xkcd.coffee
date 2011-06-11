#
# lol cats!
#

jsdom = require('jsdom').jsdom
sys = require 'sys'

module.exports.load = (bot) ->
  bot.desc 'xkcd me', 'returns a random xkcd comic'
  bot.onMessage('@marvin xkcd me', xkcd)

      
# XKCD
xkcd = (channel, from, message) ->
  self = @  
  jsdom.env({
    html: "http://dynamic.xkcd.com/random/comic",
    scripts: ['http://ajax.googleapis.com/ajax/libs/jquery/1.5.0/jquery.min.js'],
    done: (err, window) ->
      $ = window.jQuery
      title = $('#middleContent h1').text()
      src = $('#middleContent img').attr('src')
      if err
        self.message channel, "WTF I didn't find any XKCD comics. I must be sick."
      else
        self.message channel, title + ' - ' + src
  })
  true