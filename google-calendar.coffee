module.exports = (env) ->

  Promise = env.require 'bluebird'
  _ = env.require 'lodash'
  
  class GoogleCalendar extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      env.logger.info("Starting GoogleCalendar")



  return new GoogleCalendar