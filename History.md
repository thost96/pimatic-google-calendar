# Release History

* 20170428 >> v0.3.8
	* moved event pulling to seperate function

* 20170426 >> v0.3.7
	* added locale support (locale is automatically set using the pimatic local setting (default en))

* 20170425 >> v0.3.6
	* added end property for events

* 20170423 >> v0.3.5
	* fixed pulling events using interval
	* cleaned up the code

* 20170423 >> v0.3.4
	* updated dependency googleapis@18.0.0 to 19.0.0

* 20170423 >> v0.3.3
	* fixed version v0.3.2
	* added showDeleted=false to reduce of amount events pulled
	* only showing confirmed events in calendar devices

* 20170421 >> v0.3.2
	* removed time limit for last events

* 20170404 >> v0.3.1
	* added property to set the first day of week to sunday or monday of CalendarDevice

* 20170328 >> v0.3.0
	* added CalendarDevice
	* moved CalendarScheduleView, CalendarDayView, CalendarWeekView and CalendarMonthView into view property of CalendarDevice
	* removed CalendarScheduleView, CalendarDayView, CalendarWeekView and CalendarMonthView files
	* updated README.md

* 20170328 >> v0.2.9
	* added device customisation options (interval, timeFormat and contentHeight)
	* updated README.md

* 20170328 >> v0.2.8
	* replace dateFormat with momentjs
	* removed dateFormat dependency

* 20170322 >> v0.2.7
	* fixed package.json and README.md

* 20170321 >> v0.2.6
	* ouput calendar ids if debug output is enabled
	* implemented destroy function for all devices
	* cleaned up the device code

* 20170321 >> v0.2.5
	* added support for calendar id for each device
	* cleaned up the code (remove unused code for now)
	* updated the device section of README.md

* 20170321 >> v0.2.4
	* moved device classes to seperate files

* 20170321 >> v0.2.3
	* fixed image urls in README.md

* 20170318 >> v0.2.2
	* fixed wrong year in History.md
	* added image for each device

* 20170318 >> v0.2.1
	* minor fixes in README.md
	* updated googleapis dependency
	* fixed error "Error: No access or refresh token is set." at first startup

* 20170318 >> v0.2.0
	* improved event color in CalendarDayView, CalendarWeekView and CalendarMonthView
	* set height of all device to a maximum of 500px
	* added Setup and Todo section to README.md
	* updated Plugin and Device section of README.md
	* first commit to npm

* 20170317 >> v0.1.9
	* implemented deviceClass CalendarMonthView
	* added custom template for CalendarMonthView

* 20170317 >> v0.1.8
	* implemented deviceClass CalendarWeekView
	* added custom template for CalendarWeekView
	* fixed issue where no events where displayed in CalendarDayView

* 20170317 >> v0.1.7
	* fixed calendar header 
	* implemented deviceClass CalendarDayView
	* added custom template for CalendarDayView
	* modified README.md

* 20170316 >> v0.1.6
	* implemented deviceClass CalendarScheduleView
	* added CalendarScheduleView to device-config-schema.coffee
	* added custom template for CalendarScheduleView
	* added dependencies for fullcalendar

* 20170303 >> v0.1.5
	* fixed wrong version in History.md
	* code cleanup
	* implemented function to get calendar ids

* 20170303 >> v0.1.4
	* implemented function to get event colors

* 20170303 >> v0.1.3
	* added dateformat to dependencies for time calculation
	* implemented function to get events from primary calendar

* 20170303 >> v0.1.2
	* added googleapis to dependencies for authentication and access to the calendar api
	* added url /google for further use of google apis
	* added url /google/calendar for setup process
	* implemented offline authentication
	* added properties client_id, client_secret, access_token and refresh_token to google-calendar-config-schema.coffee

* 20170303 >> v0.1.1
	* fixed history link in readme

* 20170302 >> v0.1.0
	* initial release