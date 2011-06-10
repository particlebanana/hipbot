#
# Thats What She Said!
#

# Uses the ruby gem twss (https://github.com/bvandenbos/twss)
# through a shell script located in tools.

sys = require 'sys'
spawn = require('child_process').exec

module.exports.load = (bot) ->
  bot.onMessage(/^(.*)$/i, twss)


twss = (channel, from, message, matches) ->
  self = @
  str = new Buffer(matches[1]).toString('base64')

  child = spawn("twss #{str}")
    
  child.stdout.on 'data', (data) ->
    if data == 'true\n'
      self.message channel, "That's what she said!"
