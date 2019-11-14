# company_commute

An app displaying all the company&#x27;s employees&#x27; commutes. This app is entirely built with flutter.

## What it is all about

This project demonstrates an use case for using flutter as technology for app development.
_Flutter is Google’s UI toolkit for building beautiful, natively compiled applications for mobile, web, and desktop from a single codebase._ 

The idea is to match a company's employee's commutes.
An employee can enter her / his address and sees on a map the commute's waypoints and the waypoints of others. 

This project supports Android, iOS and Web. 
The project was initially started to learn about Flutter for mobile devices. 
The initial plan was to build an app for Android / iOS. We enhanced the idea with web once Mockingbird was announced.

It is - also for prototyping purposes - backed by a dart [backend](https://github.com/adorsys/company-commute-backend).

## Setup

To run this project on your own machine you'll have to 

* Get your own Google Maps [API key](https://developers.google.com/maps/documentation/android-sdk/get-api-key) and enter it in the Android Manifest and iOS's AppDelegate. 
Simply search the project for "Enter Google Maps API Key".
* Get your own Here Maps [API key](https://developer.here.com/projects) - used for the polylines and place them into the keys.dart file
* Locally start the dart [backend](https://github.com/adorsys/company-commute-backend)
* Run it!
