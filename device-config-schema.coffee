module.exports = {
  CalendarDevice:
    title: "CalendarDevice config options"
    type: "object"
    properties: {
      calendar_id:
        type: "string"
        default: "primary"
      view:
        type: "string"
        default: "month"
        enum: ["month", "week", "day", "list"]
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