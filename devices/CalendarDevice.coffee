module.exports = (env) ->

  Promise = env.require 'bluebird'
  _ = env.require 'lodash'

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
      @interval = @config.interval
      @contentHeight = @config.contentHeight
      @timeFormat = @config.timeFormat 
      @view = @config.view
      @firstDayOfWeek = @config.firstDayOfWeek
      @config.locale = @plugin.framework.config.settings.locale
      @calendar_ids = @config.calendar_ids || ["primary"] 
      @events = null
      @resolveEvents()
      @timers.push setInterval(@resolveEvents, @interval)  
      super(@config)

    destroy: () ->
      for timerId in @timers
        clearInterval timerId
      super()

    resolveEvents: () => 
      @e = []
      for @calendar_id in @calendar_ids
        @events = @plugin.getEvents(_.trim(@calendar_id)).then( (events) =>          
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
        .catch( (warn) ->
          env.logger.warn warn
        )
      @getEvents()

    getEvents: () =>         
      Promise.resolve(@events)