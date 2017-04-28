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
      @firstDayOfWeek = @config.firstDayOfWeek
      @config.locale = @plugin.framework.config.settings.locale
      @events = null
      @timers.push setInterval(@resolveEvents(), @interval)  
      super(@config)

    destroy: () ->
      for timerId in @timers
        clearInterval timerId
      super()

    resolveEvents: () =>      
      @events = @plugin.getEvents(@calendar_id).then( (events) =>
        @e = []
        for event in events
          if event.status is 'confirmed'            
            start = ""
            unless event.start.dateTime
              start = event.start.date            
            else
              start = event.start.dateTime
            end = ""
            unless event.end.dateTime
              end = event.end.date
            else
              end = event.end.dateTime
            @e.push {title: "#{event.summary}", start: "#{start}", end: "#{end}"}
        @e
      )
      @getEvents()

    getEvents: () =>          
      Promise.resolve(@events)