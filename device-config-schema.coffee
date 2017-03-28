module.exports = {
	CalendarScheduleView: 
    title: "CalendarScheduleView config options"
    type: "object"
    properties: {
      calendar_id:
        type: "string"
        default: "primary"
      interval:
        type: "number"
        default: 60000
      contentHeight:
        type: "number"
        description: "heigh of the calendar content in px"
        default: 430
      timeFormat:
        type: "string"
        default: "H:mm"
    }
  CalendarDayView:
    title: "CalendarDayView config options"
    type: "object"
    properties: {
      calendar_id:
        type: "string"
        default: "primary"
      interval:
        type: "number"
        default: 60000
      contentHeight:
        type: "number"
        description: "heigh of the calendar content in px"
        default: 430
      timeFormat:
        type: "string"
        default: "H:mm"
    }
  CalendarWeekView:
    title: "CalendarWeekView config options"
    type: "object"
    properties: {
      calendar_id:
        type: "string"
        default: "primary"
      interval:
        type: "number"
        default: 60000
      contentHeight:
        type: "number"
        description: "heigh of the calendar content in px"
        default: 430
      timeFormat:
        type: "string"
        default: "H:mm"
    }
  CalendarMonthView:
    title: "CalendarMonthView config options"
    type: "object"
    properties: {
      calendar_id:
        type: "string"
        default: "primary"
      interval:
        type: "number"
        default: 60000
      contentHeight:
        type: "number"
        description: "heigh of the calendar content in px"
        default: 430
      timeFormat:
        type: "string"
        default: "H:mm"
    }
}