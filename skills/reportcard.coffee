#
# a report card of the bots skills
#

module.exports.load = (bot) ->
  bot.onMessage('marvin help', help)


help = (channel, from, message) ->
  for phrase, functionality of @descriptions
    if functionality
      output =  phrase + ": " + functionality
    else
      output = phrase
    @message channel, output
