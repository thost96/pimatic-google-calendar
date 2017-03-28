$(document).on( "templateinit", (event) ->

  class CalendarDevice extends pimatic.DeviceItem

    constructor: (data, @device) ->
      super(data, @device)
      @id   = @device.id
      @name = @device.name
      @timeFormat = @device.config.timeFormat || @device.configDefaults.timeFormat
      @contentHeight = @device.config.contentHeight || @device.configDefaults.contentHeight
      @view = @device.config.view || @device.configDefaults.view
      switch @view
        when "month" then @defView = 'month'
        when "week" then @defView = 'agendaWeek'
        when "day" then @defView = 'agendaDay'
        when "list" then @defView = 'listMonth'

      attribute = @getAttribute("events")
      @events = ko.observable attribute.value()
      attribute.value.subscribe (newValue) =>
        @events newValue

    afterRender: (elements) -> 
      super(elements)

      @calendar = $(elements).find('.calendar-device')
      @calendar.maxHeight = "#{@contentHeight + 70}px"
      @calendar.fullCalendar
        header: {
          left: '',
          center: 'title',
          right: 'today,prev,next'
        },
        timeFormat: @timeFormat, 
        contentHeight: @contentHeight,
        defaultView: @defView,
        eventLimit: true, 
        events: @_showEvents()

    _showEvents: =>
      @getAttribute('events').value()

  pimatic.templateClasses['CalendarDevice'] = CalendarDevice
)