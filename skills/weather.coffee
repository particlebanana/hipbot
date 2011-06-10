#
# see what it's like in the human world
#

module.exports.load = (bot) ->
  bot.desc 'weather in PLACE'
  bot.onMessage(/^marvin weather in (.*)$/i, weather)


weather = (channel, from, message, matches) ->
  self = @
  place = escape(matches[1])    
  url   = "http://www.google.com/ig/api?weather=#{escape place}"
  
  @get url, (body) ->
    try
      if match = body.match(/<current_conditions>(.+?)<\/current_conditions>/)
        condition = match[1].match(/<condition data="(.+?)"/)
        icon = match[1].match(/<icon data="(.+?)"/)
        degrees = match[1].match(/<temp_f data="(.+?)"/)
        self.message channel, "#{degrees[1]}° and #{condition[1]} — http://www.google.com#{icon[1]}"
      else
        self.message channel, "i don't know that place"
    catch e
      console.log "Weather error: " + e
