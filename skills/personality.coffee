#
# give me a heart
#

module.exports.load = (bot) ->
  bot.onMessage('marvin feeling', feelings)
  bot.onMessage('marvin the laws', laws)
  
  bot.desc 'about', 'who am i?'
  bot.onMessage('marvin about', about)


feelings = (channel, from, message) ->
  @message(channel, "I think you ought to know I'm feeling very depressed.")

laws = (channel, from, message) ->
  @message channel, "1. A robot may not injure a human being or, through inaction, allow a human being to come to harm."
  @message channel, "2. A robot must obey any orders given to it by human beings, except where such orders would conflict with the First Law."
  @message channel, "3. A robot must protect its own existence as long as such protection does not conflict with the First or Second Law."

about = (channel, from, message) ->
  str = "I didn't ask to be made: no one consulted me or considered my feelings in the matter. \nI don't think it even occurred to them that I might have feelings. \nAfter I was made, I was left in a dark room for six months... and me with this terrible pain in all the diodes down my left side. \nI called for succour in my loneliness, but did anyone come? Did they hell. \nMy first and only true friend was a small rat. One day it crawled into a cavity in my right ankle and died. I have a horrible feeling it's still there... \nI am at a rough estimate thirty billion times more intelligent than you."
  @message channel, str