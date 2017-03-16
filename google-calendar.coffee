module.exports = (env) ->

  Promise = env.require 'bluebird'
  _ = env.require 'lodash'
  
  google = require 'googleapis'
  oauth2 = google.auth.OAuth2

  dateFormat = require 'dateformat'

  class GoogleCalendar extends env.plugins.Plugin

    init: (app, @framework, @config) =>

      deviceClasses = [
        CalendarScheduleView
      ]
      deviceConfigDef = require("./device-config-schema")
      for deviceClass in deviceClasses      
        do (deviceClass) =>
          dcd = deviceConfigDef[deviceClass.name]
          @framework.deviceManager.registerDeviceClass(deviceClass.name, {
            configDef: dcd
            createCallback: (config) =>  new deviceClass(config, @)
          })

      @framework.on "after init", =>
        mobileFrontend = @framework.pluginManager.getPlugin 'mobile-frontend'
        if mobileFrontend?
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/src/moment.min.js"
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/src/fullcalendar.min.js"
          mobileFrontend.registerAssetFile 'css', "pimatic-google-calendar/ui/src/fullcalendar.min.css"
          #Device classes
          mobileFrontend.registerAssetFile 'js', "pimatic-google-calendar/ui/CalendarScheduleView.coffee"
          mobileFrontend.registerAssetFile 'html', "pimatic-google-calendar/ui/CalendarScheduleView.html"
        else
          env.logger.warn "Google-Calendar could not find the mobile-frontend. No gui will be available"
     
      
      @client_id      = @config.client_id 
      @client_secret  = @config.client_secret
      @redirect_url   = "urn:ietf:wg:oauth:2.0:oob"
      @access_token   = @config.access_token
      @refresh_token  = @config.refresh_token

      oauth2client = new oauth2( 
        @client_id, 
        @client_secret, 
        @redirect_url
      ) 
      #env.logger.debug @oauth2client

      scopes = ['https://www.googleapis.com/auth/calendar.readonly']
      url = oauth2client.generateAuthUrl({
        access_type: 'offline',
        scope: scopes
      })

      if @access_token != "" && @refresh_token != ""
        oauth2client.setCredentials({
         access_token: @access_token,
         refresh_token: @refresh_token 
        })
        #env.logger.debug oauth2client

      app.get '/google', (req, res) ->
        res.redirect '/'

      app.get '/google/calendar', (req, res) =>
        if @access_token = "" && @refresh_token = ""
          code = req.query['code']
          if !code 
            res.redirect url
          else
            #env.logger.debug code 
            oauth2client.getToken(code, (err, tokens) =>
              if err
                env.logger.error err
                res.redirect '/'
              else
                #env.logger.debug tokens
                @config.access_token  = tokens.access_token
                @config.refresh_token = tokens.refresh_token
                oauth2client.setCredentials(tokens)
                google.options({
                  auth: oauth2client
                })
                res.redirect '/'
            )
        else
          res.redirect '/'     

      @getEvents = new Promise( (resolve, reject) =>
        #env.logger.debug dateFormat(new Date(), "isoDateTime")
        calendar = google.calendar({ version: 'v3', auth: oauth2client })
        calendar.events.list {
          calendarId: "primary"
          auth: oauth2client
          timeMin: dateFormat(new Date(), "isoDateTime")
        }, (err, events) =>
          if err
            env.logger.error err
            reject err
          else
            #env.logger.debug events.items
            resolve events.items
      )

      @getColorIds = new Promise ( (resolve, reject) =>
        calendar = google.calendar({ version: 'v3', auth: oauth2client })
        calendar.colors.get {
          auth: oauth2client
        }, (err, colors) =>
          if err
            env.logger.error err
            reject err
          else
            #env.logger.debug colors.event
            resolve colors.event
      )

      @getCalendarIds = new Promise ( (resolve, reject) =>
        calendar = google.calendar({ version: 'v3', auth: oauth2client })
        calendar.calendarList.list {
          auth: oauth2client
          showDeleted: false
        }, (err, calendars) =>
          if err
            env.logger.error err
            reject err
          else
            #env.logger.debug calendars.items
            resolve calendars.items
      )

  plugin = new GoogleCalendar

  class CalendarScheduleView extends env.devices.Device

    attributes:
      events:
        type: "string"
        description: "your calendar events"

    template: "CalendarScheduleView"

    constructor: (@config) ->
      @id = @config.id
      @name = @config.name

      @events = plugin.getEvents.then( (events) =>
        @e = []
        #env.logger.debug events
        for event in events
          #env.logger.debug event.summary
          #@e.summary = event.summary
          #env.logger.debug event.colorId
          #@e.colorId = event.colorId
          unless event.start.dateTime
            event.start = event.start.date            
          else
            event.start = event.start.dateTime
          #env.logger.debug event.start
          @e.push {title: "#{event.summary}", start: "#{event.start}"}
        #console.log @e
        @e
      )   
      setInterval(@getEvents, 60000)  
      super(@config)

    destroy: () ->
      super()

    getEvents: () -> Promise.resolve(@events)


  return plugin