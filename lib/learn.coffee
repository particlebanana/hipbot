_ = require 'underscore'

module.exports = Skills = {}

Skills.autoload =  (bot, skills_path) ->
  fs = require "fs"
  path = require "path"
  sys = require "sys"
  files = fs.readdirSync(skills_path)
  names = _.map(files, (f) ->
    return path.basename f
  )

  _.each(names, (skill) ->
    bot.loadPlugin skill, require( skills_path + "/" + skill )
  )