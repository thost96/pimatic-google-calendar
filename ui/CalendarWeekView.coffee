$(document).on( "templateinit", (event) ->

  class CalendarWeekView extends pimatic.DeviceItem

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

      @calendar = $(elements).find('.calendar-week')
      @calendar.fullCalendar
        header: {
          left: '',
          center: 'title',
          right: 'today,prev,next'
        },
        timeFormat: 'H:mm',
        contentHeight: 430,
        defaultView: 'agendaWeek',
        eventLimit: true, 
        events: @_showWeekEvents()

    _showWeekEvents: =>
      @getAttribute('events').value()

  pimatic.templateClasses['CalendarWeekView'] = CalendarWeekView
)