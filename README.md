# pimatic-google-calendar

[![npm version](https://badge.fury.io/js/pimatic-google-calendar.svg)](http://badge.fury.io/js/pimatic-google-calendar)
[![dependencies status](https://david-dm.org/thost96/pimatic-google-calendar/status.svg)](https://david-dm.org/thost96/pimatic-google-calendar)
[![Build Status](https://travis-ci.org/thost96/pimatic-google-calendar.svg?branch=master)](https://travis-ci.org/thost96/pimatic-google-calendar)

![Google Calendar](https://upload.wikimedia.org/wikipedia/commons/thumb/e/e9/Google_Calendar.png/145px-Google_Calendar.png)

A pimatic plugin to display, interact and build rules with your **Google** Calendar.

## Setup 
1. Create your own project with OAuth 2.0 credentials by following these [instructions](https://developers.google.com/api-client-library/javascript/start/start-js#Getkeysforyourapplication)

> If you are running on a private IP address that the Google service cannot reach, please configure the authorized Redirect URIs of your app to include the following url: `http://pimatic.example.com/google/auth/callback` You will need to edit your [hosts file](https://en.wikipedia.org/wiki/Hosts_(file)) and add an entry for pimatic.example.com that points to your local pimatic ip address.

2. Copy the credentials to the config of the pimatic-google-calendar plugin
3. Restart Pimatic 

## Plugin Configuration

	{
          "plugin": "google-calendar",
          "client_id": "",
          "client_secret": ""
    }

The plugin has the following configuration properties:

| Property          | Default  | Type    | Description                                 |
|:------------------|:---------|:--------|:--------------------------------------------|
| client_id         | -		   | String  | Your client id from the setup above |
| client_secret     | -		   | String  | Your client secrect from the setup above |
| access_token      | -		   | String  | automatically generated access token |
| refresh_token     | -    	   | String  | automatically generated refresh token |
| debug             | false    | Boolean | Debug mode. Writes debug messages to the pimatic log, if set to true |

## Device Configuration
The following device can be created: 

#### CalendarDevice

	{
			"id": "",
			"name": "",
			"class": "CalendarDevice"
	}

The device has the following configuration properties:

| Property          | Default    | Type    | Description                                 |
|:------------------|:-----------|:--------|:--------------------------------------------|
| calendar_ids      | ["primary"]| Array   | calendar ids used to fetch events |
| view 				| "month"    | String  | diffent views of the calendar eg. month, week, day or list |
| interval          | 60000      | Number  | interval for fetching events |
| contentHeight     | 430        | Number  | content height in px |
| timeFormat        | "H:mm"     | String  | time format, for more details see [here](https://fullcalendar.io/docs/text/timeFormat/) |
| firstDayOfWeek	| "sunday"   | String  | first day of week (sunday or monday) |
| locale			| -	         | String  | automatically set locale from pimatic locale setting in config.json. Default pimatic locale is "en" |

If you don't know your calendar ids, set the debug option of the plugin to true. All availble ids will be logged. 

![ListView](https://github.com/thost96/pimatic-google-calendar/raw/master/assets/ListView.jpg)
![DayView](https://github.com/thost96/pimatic-google-calendar/raw/master/assets/DayView.jpg)
![WeekView](https://github.com/thost96/pimatic-google-calendar/raw/master/assets/WeekView.jpg)
![MonthView](https://github.com/thost96/pimatic-google-calendar/raw/master/assets/MonthView.jpg)

## ToDo

* add support for rules
* implement event colors
* use sweetAlert2 for setup

## History

See [Release History](https://github.com/thost96/pimatic-google-calendar/blob/master/History.md).

## License 

Copyright (c) 2017, Thorsten Reichelt and contributors. All rights reserved.

License: [GPL-2.0](https://github.com/thost96/pimatic-google-calendar/blob/master/LICENSE.md).
