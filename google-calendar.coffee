module.exports = (env) ->

  Promise = env.require 'bluebird'
  _ = env.require 'lodash'
  google = require 'googleapis'
  oauth2 = google.auth.OAuth2

  CalendarDevice = require('./devices/CalendarDevice')(env)

  class GoogleCalendar extends env.plugins.Plugin

    init: (app, @framework, @config) =>

      deviceConfigDef = require("./device-config-schema")
      env.logger.debug "Registering device class CalendarDevice"
      @framework.deviceManager.registerDeviceClass("CalendarDevice", {
        configDef: deviceConfigDef.CalendarDevice,
        createCallback: (config) => new CalendarDevice(config, @)
      })

      @framework.on "after init", =>
        mobileFrontend = @framework.pluginManager.getPlugin 'mobile-frontend'
        if mobileFrontend?
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/src/moment.min.js"
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/src/fullcalendar.min.js"
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/src/locale-all.js"
          mobileFrontend.registerAssetFile 'css', "pimatic-google-calendar/ui/src/fullcalendar.min.css"
          mobileFrontend.registerAssetFile 'css', "pimatic-google-calendar/ui/styles.css"          
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/CalendarDevice.coffee"
          mobileFrontend.registerAssetFile 'html', "pimatic-google-calendar/ui/CalendarDevice.html"
        else
          env.logger.warn "Google-Calendar could not find the mobile-frontend. No gui will be available"   
      
      @client_id      = @config.client_id 
      @client_secret  = @config.client_secret
      @redirect_url   = "urn:ietf:wg:oauth:2.0:oob"
      @access_token   = @config.access_token || ""
      @refresh_token  = @config.refresh_token || ""

      @oauth2client = new oauth2( 
        @client_id, 
        @client_secret, 
        @redirect_url
      ) 

      scopes = ['https://www.googleapis.com/auth/calendar.readonly']
      url = @oauth2client.generateAuthUrl({
        access_type: 'offline',
        scope: scopes
      })

      if !_.isEmpty(@access_token) && !_.isEmpty(@refresh_token)
        @oauth2client.setCredentials({
         access_token: @access_token,
         refresh_token: @refresh_token 
        })

      app.get '/google', (req, res) ->
        res.redirect '/'

      app.get '/google/calendar', (req, res) =>
        if _.isEmpty(@access_token) && _.isEmpty(@refresh_token)
          code = req.query['code']
          if !code 
            res.redirect url
          else
            @oauth2client.getToken(code, (err, tokens) =>
              if err
                env.logger.error err
                res.redirect '/'
              else
                @config.access_token  = tokens.access_token
                @access_token = tokens.access_token
                @config.refresh_token = tokens.refresh_token
                @refresh_token = tokens.refresh_token
                @oauth2client.setCredentials(tokens)
                google.options({
                  auth: @oauth2client
                })
                res.redirect '/'
            )
        else
          res.redirect '/'     

      @getCalendarIds().then( (calendar_ids) ->
        env.logger.debug "All possible calendar ids from your account:"
        for calendar_id in calendar_ids
          env.logger.debug calendar_id
      )

    getColorIds: () =>
      return new Promise ( (resolve, reject) =>
        if !_.isEmpty(@access_token) && !_.isEmpty(@refresh_token)
          calendar = google.calendar({ version: 'v3', auth: @oauth2client })
          calendar.colors.get {
            auth: @oauth2client
          }, (err, colors) =>
            if !err
              env.logger.debug colors
              resolve colors
      )

    getCalendarIds: () =>
      return new Promise ( (resolve, reject) =>
        if !_.isEmpty(@access_token) && !_.isEmpty(@refresh_token)
          calendar = google.calendar({ version: 'v3', auth: @oauth2client })
          calendar.calendarList.list {
            auth: @oauth2client
            showDeleted: false
          }, (err, calendars) =>
            if !err
              ids = []
              for calendar in calendars.items
                ids.push calendar.id
              resolve ids
      )      

    getEvents: (calendar_id) =>
      return new Promise( (resolve, reject) =>
        if !_.isEmpty(@access_token) && !_.isEmpty(@refresh_token)
          calendar = google.calendar({ version: 'v3', auth: @oauth2client })
          calendar.events.list {
            calendarId: "#{calendar_id}"
            auth: @oauth2client
            showDeleted: false
          }, (err, events) =>
            if !err
              resolve events.items
      )

  return new GoogleCalendar