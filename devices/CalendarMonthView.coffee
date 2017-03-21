module.exports = (env) ->

  Promise = env.require 'bluebird'

  class CalendarMonthView extends env.devices.Device
    
    attributes:
      events:
        type: "string"
        description: "your calendar events"

    template: "CalendarMonthView"

    constructor: (@config, @plugin) ->
      @id = @config.id
      @name = @config.name
      @calendar_id = @config.calendar_id

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
      setInterval(@getEvents, 60000)  
      super(@config)

    destroy: () ->
      super()

    getEvents: () -> Promise.resolve(@events)