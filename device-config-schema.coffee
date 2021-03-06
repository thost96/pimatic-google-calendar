module.exports = {
  CalendarDevice:
    title: "CalendarDevice config options"
    type: "object"
    properties: {
      calendar_ids:
        type: "array"
        default: ["primary"]
        format: "table"
        items:
          type: "string"
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
      firstDayOfWeek:
        type: "string"
        default: "sunday"
        enum: ["sunday", "monday"]
      locale:
        type: "string"
        description: "automatically set to pimatic locale via plugin"
        required: false
    }
}