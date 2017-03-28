$(document).on( "templateinit", (event) ->

  class CalendarDayView extends pimatic.DeviceItem

    constructor: (data, @device) ->
      super(data, @device)
      @id   = @device.id
      @name = @device.name
      @timeFormat = @device.config.timeFormat || @device.configDefaults.timeFormat
      @contentHeight = @device.config.contentHeight || @device.configDefaults.contentHeight
      
      attribute = @getAttribute("events")
      @events = ko.observable attribute.value()
      attribute.value.subscribe (newValue) =>
        @events newValue

    afterRender: (elements) -> 
      super(elements)

      @calendar = $(elements).find('.calendar-day')
      @calendar.maxHeight = "#{@contentHeight + 70}px"
      @calendar.fullCalendar
        header: {
          left: '',
          center: 'title',
          right: 'today,prev,next'
        },
        timeFormat: @timeFormat,
        contentHeight: @contentHeight,
        defaultView: 'agendaDay',
        eventLimit: true, 
        events: @_showDailyEvents()

    _showDailyEvents: =>
      @getAttribute('events').value()

  pimatic.templateClasses['CalendarDayView'] = CalendarDayView
)