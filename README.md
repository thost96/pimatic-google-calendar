# pimatic-google-calendar

[![npm version](https://badge.fury.io/js/pimatic-google-calendar.svg)](http://badge.fury.io/js/pimatic-google-calendar)
[![dependencies status](https://david-dm.org/thost96/pimatic-google-calendar/status.svg)](https://david-dm.org/thost96/pimatic-google-calendar)

A pimatic plugin to display and interact with your google calendar.

## Setup 

 1. Use this [wizard](https://console.developers.google.com/start/api?id=calendar) to create a project in the Google Developers Console and automatically turn on the API. Click **Continue**, then **Go to credentials** .
 2. On the left of the page, select **Credentials**, then at the top of the page, select the **OAuth consent screen** tab. Select an **Email address**, enter a **Product name** if not already set, and click the **Save** button.
 3. Select the **Credentials tab**, click the **Create credentials** button and select **OAuth client ID**.
 4. Select the application type **Other**, enter the name "pimatic-google-calendar", and click the **Create** button.
 5. Go to your Pimatic webinterface and open the **plugin page**. Under **Browse Plugins** search for google-calendar and click **install**.
 6. Restart Pimatic. 
 7. On the google-calendar settings page enter your **client id** and **client secret** from the Google Developers Console and click **save**.
 8. Restart Pimatic again. 
 9. Open http(s)://pimatic-ip/google/calendar and sign in with your Google Account and allow read access to your calendar. 
10. Copy the code from the textbox
11. Open http(s)://pimatic-ip/google/calendar?auth="your copied code here"
12. Restart Pimatic again. 

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
The following devices can be created: 

#### CalendarScheduleView
![CalendarScheduleView](https://github.com/thost96/pimatic-google-calendar/raw/master/assets/CalendarScheduleView.jpg)

	{
			"id": "",
			"name": "",
			"class": "CalendarScheduleView"
	}

#### CalendarDayView
![CalendarDayView](https://github.com/thost96/pimatic-google-calendar/raw/master/assets/CalendarDayView.jpg)

	{
			"id": "",			
			"name": "",
			"class": "CalendarDayView"
	}

#### CalendarWeekView
![CalendarWeekView](https://github.com/thost96/pimatic-google-calendar/raw/master/assets/CalendarWeekView.jpg)

	{
			"id": "",			
			"name": "",
			"class": "CalendarWeekView"
	}

#### CalendarMonthView
![CalendarMonthView](https://github.com/thost96/pimatic-google-calendar/raw/master/assets/CalendarMonthView.jpg)

	{
			"id": "",
			"name": "",
			"class": "CalendarMonthView"
	}

## ToDo

* add support for multiple calendars
* add support for rules
* add customization options for all devices
* add locale support
* implement event colors
* use sweetAlert2 for setup

## History

See [Release History](https://github.com/thost96/pimatic-google-calendar/blob/master/History.md).

## License 

Copyright (c) 2017, Thorsten Reichelt and contributors. All rights reserved.

License: [GPL-2.0](https://github.com/thost96/pimatic-google-calendar/blob/master/LICENSE.md).