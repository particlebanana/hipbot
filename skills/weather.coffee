#
# see what it's like in the human world
#

module.exports.load = (bot) ->
  bot.desc 'weather in ZIP'
  bot.onMessage(/^@marvin weather in (.*)$/i, weather)


weather = (channel, from, message, matches) ->
  self = @
  place = escape(matches[1])    
  url   = "http://query.yahooapis.com/v1/public/yql/jonathan/weather?format=json&zip=" + place
  
  @get url, (body) ->
    try
      item = body.query.results.channel.item
      if !item.condition
        response = "you must give me a zip code to lookup"
      else
        response = item.title + ': ' + item.condition.temp + ' degrees and ' + item.condition.text
        
      self.message channel, "@" + from.split(' ')[0] + ' ' + response
    catch e
      console.log "Weather error: " + e
  true
