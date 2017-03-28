module.exports = (env) ->

  Promise = env.require 'bluebird'

  class CalendarScheduleView extends env.devices.Device

    attributes:
      events:
        type: "string"
        description: "your calendar events"

    template: "CalendarScheduleView"

    constructor: (@config, @plugin) ->
      @id = @config.id
      @name = @config.name
      @timers = []
      @calendar_id = @config.calendar_id
      @interval = @config.interval
      @contentHeight = @config.contentHeight
      @timeFormat = @config.timeFormat 

      @events = @plugin.getEvents(@calendar_id).then( (events) =>
        @e = []
        for event in events
          start = ""
          unless event.start.dateTime
            start = event.start.date            
          else
            start = event.start.dateTime
          @e.push {title: "#{event.summary}", start: "#{start}"}
        @e
      )   
      @timers.push setInterval(@getEvents, @interval)  
      super(@config)

    destroy: () ->
      for timerId in @timers
        clearInterval timerId
      super()

    getEvents: () -> Promise.resolve(@events)