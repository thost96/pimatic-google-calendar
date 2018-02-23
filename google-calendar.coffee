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
      @redirect_url   = "http://pimatic.example.com/google/auth/callback"
      @access_token   = ""
      @refresh_token  = @config.refresh_token || ""
      @expiry_date    = @config.expiry_date || ""
      @timer          = []

      @oauth2client = new oauth2( 
        @client_id, 
        @client_secret, 
        @redirect_url
      ) 
      #console.log "oauth2client:"
      #console.log @oauth2client

      scopes = ['https://www.googleapis.com/auth/calendar.readonly']
      url = @oauth2client.generateAuthUrl({
        access_type: 'offline',
        scope: scopes
      })
      #console.log url
      #bring url ti frontend
      #env.logger.error "please open the following url to authorize your google account"
      #env.logger.error url

      #if !_.isEmpty(@refresh_token)
      #  @timers.push setInterval(@refreshAccessToken(), @interval)
      ###          
      if !_.isEmpty(@access_token) 
        @oauth2client.setCredentials({
         access_token: @access_token
        })
      ###


      #access token noch gültig
      #access token brauch nicht gespeichert werden
      @oauth2client.isAccessTokenExpired()

      app.get '/google', (req, res) ->
        res.redirect '/'

      #other way then using the frontend
      app.get '/google/auth', (req, res) ->
        res.redirect url

      app.get '/google/auth/callback', (req, res) =>
        if _.isEmpty(@access_token) #|| _.isEmpty(@refresh_token)
          code = req.query['code']
          #console.log "code:"
          #console.log code
          if !code 
            res.redirect url
          else
            @getTokens(code)
            res.redirect '/'
        else
          res.redirect '/'     

      @getCalendarIds().then( (calendar_ids) ->
        env.logger.debug "All possible calendar ids from your account:"
        for calendar_id in calendar_ids
          env.logger.debug calendar_id
      )

    destroy: () ->
      for timerId in @timers
        clearInterval timerId
      super()

    refreshAccessToken: () =>
      @oauth2client.refreshAccessToken( (err, tokens) =>
        if err
          env.logger.error err
        else
          console.log(tokens)
          @oauth2Client.credentials = {access_token : tokens.access_token}
          google.options({
            auth: @oauth2client
          })
      ) 

    getTokens: (code) ->
      @oauth2client.getToken(code, (err, tokens) =>
        if err
          env.logger.error err
        else
          console.log tokens 
          ###
          { access_token: 'ya29.GltrBfGHMHyICWK4AJOAJpvR1XJPlcUxCFGrLqpxYGqQjhnu5nffPYew1XRrsMSLxfzxrswCsGIzBDjKGX932xE929-XiNSPtRYkJwDKzeNnjMMQtvX_xgmr3rAs',
          token_type: 'Bearer',
          refresh_token: '1/txtQOmhZMXiXpKKDWhJbgndYMHVli8IO-sO7QgN5MBE',
          expiry_date: 1519397961058 }
          ###
          @config.access_token  = tokens.access_token
          @access_token         = tokens.access_token
          @config.refresh_token = tokens.refresh_token
          @refresh_token        = tokens.refresh_token
          @config.expiry_date   = tokens.expiry_date
          @expiry_date          = tokens.expiry_date
          
          @oauth2client.setCredentials(tokens)
          google.options({
            auth: @oauth2client
          })
      )

    getColorIds: () =>
      return new Promise ( (resolve, reject) =>
        if !_.isEmpty(@access_token)
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
        if !_.isEmpty(@access_token)
          calendar = google.calendar({ version: 'v3', auth: @oauth2client })
          #console.log calendar
          calendar.calendarList.list {
            auth: @oauth2client
            showDeleted: false
          }, (err, calendars) =>
            if err
              env.logger.err err
              reject err
            else
              ids = []
              #console.log calendars.data.items
              #if primary is true ??
              if !_.isEmpty(calendars)
                for calendar in calendars.data.items
                  ids.push calendar.id
                resolve ids
              else
                resolve []              
      )      

    getEvents: (calendar_id) =>
      return new Promise( (resolve, reject) =>
        if !_.isEmpty(@access_token)
          calendar = google.calendar({ version: 'v3', auth: @oauth2client })
          #console.log calendar_id
          calendar.events.list {
            calendarId: "#{calendar_id}"
            auth: @oauth2client
            showDeleted: false
          }, (err, events) =>
            if err
              console.log err
            else
              resolve events.data.items
      )

  return new GoogleCalendar