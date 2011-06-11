#
# find some images
#

module.exports.load = (bot) ->
  bot.desc 'image me PHRASE'
  bot.onMessage(/^@marvin image me (.*)$/i, images)


images = (channel, from, message, matches) ->
  self = @
  phrase = escape(matches[1])
  url = "http://ajax.googleapis.com/ajax/services/search/images?v=1.0&rsz=8&safe=active&q=#{phrase}"
  
  @get url, (body) ->
    try
      images = body.responseData.results
      image  = images[ Math.floor(Math.random()*images.length) ]
      self.message channel, image.unescapedUrl
    catch e
      console.log "Image error: " + e
  
  true
