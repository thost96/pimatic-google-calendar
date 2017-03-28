module.exports = (env) ->

  Promise = env.require 'bluebird'
  _ = env.require 'lodash'
  moment = env.require 'moment'
  
  google = require 'googleapis'
  oauth2 = google.auth.OAuth2

  deviceTypes = {}
  for device in [
    'CalendarScheduleView'
    'CalendarDayView'
    'CalendarWeekView'
    'CalendarMonthView'
  ]
    className = device.replace /(^[a-z])|(\-[a-z])/g, ($1) -> $1.toUpperCase()
    deviceTypes[className] = require('./devices/' + device)(env)

  class GoogleCalendar extends env.plugins.Plugin

    init: (app, @framework, @config) =>

      deviceConfigDef = require("./device-config-schema")
      for className, classType of deviceTypes    
        env.logger.debug "Registering device class #{className}"
        @framework.deviceManager.registerDeviceClass(className, {
          configDef: deviceConfigDef[className],
          createCallback: @callbackHandler(className, classType)
        })

      @framework.on "after init", =>
        mobileFrontend = @framework.pluginManager.getPlugin 'mobile-frontend'
        if mobileFrontend?
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/src/moment.min.js"
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/src/fullcalendar.min.js"
          mobileFrontend.registerAssetFile 'css', "pimatic-google-calendar/ui/src/fullcalendar.min.css"
          mobileFrontend.registerAssetFile 'css', "pimatic-google-calendar/ui/styles.css"
          #Device classes
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/CalendarScheduleView.coffee"
          mobileFrontend.registerAssetFile 'html', "pimatic-google-calendar/ui/CalendarScheduleView.html"
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/CalendarDayView.coffee"
          mobileFrontend.registerAssetFile 'html', "pimatic-google-calendar/ui/CalendarDayView.html"
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/CalendarWeekView.coffee"
          mobileFrontend.registerAssetFile 'html', "pimatic-google-calendar/ui/CalendarWeekView.html"
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/CalendarMonthView.coffee"
          mobileFrontend.registerAssetFile 'html', "pimatic-google-calendar/ui/CalendarMonthView.html"
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

      ###
      @getColorIds = new Promise ( (resolve, reject) =>
        if !_.isEmpty(@access_token) && !_.isEmpty(@refresh_token)
          calendar = google.calendar({ version: 'v3', auth: @oauth2client })
          calendar.colors.get {
            auth: @oauth2client
          }, (err, colors) =>
            if err
              env.logger.error err
              reject err
            else
              #env.logger.debug colors.event
              resolve colors.event
      )
      ###
      @getCalendarIds = new Promise ( (resolve, reject) =>
        if !_.isEmpty(@access_token) && !_.isEmpty(@refresh_token)
          calendar = google.calendar({ version: 'v3', auth: @oauth2client })
          calendar.calendarList.list {
            auth: @oauth2client
            showDeleted: false
          }, (err, calendars) =>
            if err
              env.logger.error err
              reject err
            else
              ids = []
              for calendar in calendars.items
                ids.push calendar.id
              resolve ids
      )
      @getCalendarIds.then( (calendar_ids) ->
        env.logger.debug "All possible calendar ids from your account:"
        for calendar_id in calendar_ids
          env.logger.debug calendar_id
      )

    callbackHandler: (className, classType) ->
      return (config) =>
        return new classType(config, @)

    getEvents: (calendar_id) =>
      return new Promise( (resolve, reject) =>
        oauth = @oauth2client
        if !_.isEmpty(@access_token) && !_.isEmpty(@refresh_token)
          calendar = google.calendar({ version: 'v3', auth: oauth })
          calendar.events.list {
            calendarId: "#{calendar_id}"
            auth: oauth
            timeMin: moment().format()
          }, (err, events) =>
            if err
              env.logger.error err
              reject err
            else
              resolve events.items
      )

  return new GoogleCalendar