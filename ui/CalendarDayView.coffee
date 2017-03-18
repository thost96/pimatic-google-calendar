$(document).on( "templateinit", (event) ->

  class CalendarDayView extends pimatic.DeviceItem

    constructor: (data, @device) ->
      super(data, @device)
      @id   = @device.id
      @name = @device.name
      
      attribute = @getAttribute("events")
      @events = ko.observable attribute.value()
      attribute.value.subscribe (newValue) =>
        @events newValue

    afterRender: (elements) -> 
      super(elements)

      @calendar = $(elements).find('.calendar-day')
      @calendar.fullCalendar
        header: {
          left: '',
          center: 'title',
          right: 'today,prev,next'
        },
        timeFormat: 'H:mm',
        contentHeight: 430,
        defaultView: 'agendaDay',
        eventLimit: true, 
        events: @_showDailyEvents()

    _showDailyEvents: =>
      @getAttribute('events').value()

  pimatic.templateClasses['CalendarDayView'] = CalendarDayView
)