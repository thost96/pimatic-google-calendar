module.exports = (env) ->

  Promise = env.require 'bluebird'

  class CalendarDevice extends env.devices.Device
    
    attributes:
      events:
        type: "string"
        description: "your calendar events"

    template: "CalendarDevice"

    constructor: (@config, @plugin) ->
      @id = @config.id
      @name = @config.name
      @timers = []
      @calendar_id = @config.calendar_id
      @interval = @config.interval
      @contentHeight = @config.contentHeight
      @timeFormat = @config.timeFormat 
      @view = @config.view

      @events = @plugin.getEvents(@calendar_id).then( (events) =>
        @e = []
        #env.logger.debug events
        for event in events
          #env.logger.debug event.summary
          #@e.summary = event.summary
          #env.logger.debug event.colorId
          #@e.colorId = event.colorId
          #env.logger.debug event.start
          start = ""
          unless event.start.dateTime
            start = event.start.date            
          else
            start = event.start.dateTime
          #env.logger.debug event.start
          @e.push {title: "#{event.summary}", start: "#{start}"}
        #console.log @e
        @e
      )   
      @timers.push setInterval(@getEvents, @interval)  
      super(@config)

    destroy: () ->
      for timerId in @timers
        clearInterval timerId
      super()

    getEvents: () -> Promise.resolve(@events)