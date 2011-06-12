#
# Hello. I am hipbot. I am a robot.
#
# Some of this is stolen from Evilbot (https://github.com/defunkt/evilbot) 
# which is somewhat stolen from github's Hubot. 
# It also has some inspiration from Robut (https://github.com/justinweiss/robut)
# And a dash of love from Wobot (https://github.com/cjoudrey/wobot/)
#
# I guess you could say this is the bastard son of the bots.
# He's still a loveable little bot though.
#


#
# robot parts
#

Brain = require('./lib/brain').Brain

#
# boot up robot
#

options = {
  jid: env.HIPBOT_JID
  password: env.HIPBOT_PASSWORD
  name: env.HIPBOT_NAME
  debug: false
}

skills_path = __dirname + '/skills'

marvin = new Brain options

require("./lib/learn").autoload marvin, skills_path
marvin.connect()

marvin.onConnect () ->
  console.log 'connected'
  @join(env.HIPBOT_ROOM)