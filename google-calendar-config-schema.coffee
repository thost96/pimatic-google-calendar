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
      description: "auto generated access token for your google account"
      type: "string"
      required: false
    refresh_token:
      description: "auto generated refresh token for your google account"
      type: "string"
      required: false
    expiry_date:
      description: "auto generated expiry date"
      type: "number"
      required: false
}