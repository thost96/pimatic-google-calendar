module.exports = (env) ->

  Promise = env.require 'bluebird'
  _ = env.require 'lodash'
  
  google = require 'googleapis'
  oauth2 = google.auth.OAuth2

  dateFormat = require 'dateformat'

  class GoogleCalendar extends env.plugins.Plugin

    init: (app, @framework, @config) =>
      #env.logger.debug("Starting GoogleCalendar")

      @client_id      = @config.client_id 
      @client_secret  = @config.client_secret
      @redirect_url   = "urn:ietf:wg:oauth:2.0:oob"
      #env.logger.debug @client_id
      #env.logger.debug @client_secret

      @access_token   = @config.access_token
      @refresh_token  = @config.refresh_token

      oauth2client = new oauth2( 
        @client_id, 
        @client_secret, 
        @redirect_url
      ) 
      #env.logger.debug @oauth2client

      scopes = ['https://www.googleapis.com/auth/calendar']

      url = oauth2client.generateAuthUrl({
        access_type: 'offline',
        scope: scopes
      })
      #env.logger.debug url

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
          #env.logger.debug "tokens not ready"
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
          #env.logger.debug "tokens already ready"
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
            env.logger.debug events.items
            resolve events.items
      )


  return new GoogleCalendar