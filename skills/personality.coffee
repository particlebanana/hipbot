#
# give me a heart
#

module.exports.load = (bot) ->
  bot.onMessage('@marvin feeling', feelings)
  bot.onMessage('@marvin the laws', laws)
  
  bot.desc 'about', 'who am i?'
  bot.onMessage('@marvin about', about)


feelings = (channel, from, message) ->
  @message(channel, "I think you ought to know I'm feeling very depressed.")

laws = (channel, from, message) ->
  @message channel, "1. A robot may not injure a human being or, through inaction, allow a human being to come to harm."
  @message channel, "2. A robot must obey any orders given to it by human beings, except where such orders would conflict with the First Law."
  @message channel, "3. A robot must protect its own existence as long as such protection does not conflict with the First or Second Law."

about = (channel, from, message) ->
  str = "I am at a rough estimate thirty billion times more intelligent than you."
  @message channel, str