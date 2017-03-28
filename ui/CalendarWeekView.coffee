$(document).on( "templateinit", (event) ->

  class CalendarWeekView extends pimatic.DeviceItem

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

      @calendar = $(elements).find('.calendar-week')
      @calendar.maxHeight = "#{@contentHeight + 70}px"
      @calendar.fullCalendar
        header: {
          left: '',
          center: 'title',
          right: 'today,prev,next'
        },
        timeFormat: @timeFormat,
        contentHeight: @contentHeight,
        defaultView: 'agendaWeek',
        eventLimit: true, 
        events: @_showWeekEvents()

    _showWeekEvents: =>
      @getAttribute('events').value()

  pimatic.templateClasses['CalendarWeekView'] = CalendarWeekView
)