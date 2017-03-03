module.exports = {
  title: "google-calendar config options"
  type: "object"
  properties:
    debug:
      description: "debug output"
      type: "boolean"
      default: false
    client_id:
      description: "your google calendar client id"
      type: "string"
      required: true
    client_secret:
      description: "your google calendar client secret"
      type: "string"
      required: true
    access_token:
      description: " "
      type: "string"
      required: false
    refresh_token:
      description: " "
      type: "string"
      required: false
}