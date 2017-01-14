# BikeProvider

[![CI Status](https://travis-ci.org/superpeteblaze/BikeProvider.svg?branch=master)](https://travis-ci.org/superpeteblaze/BikeProvider)
[![Version](https://img.shields.io/cocoapods/v/BikeProvider.svg?style=flat)](http://cocoapods.org/pods/BikeProvider)
[![License](https://img.shields.io/cocoapods/l/BikeProvider.svg?style=flat)](http://cocoapods.org/pods/BikeProvider)
[![Platform](https://img.shields.io/cocoapods/p/BikeProvider.svg?style=flat)](http://cocoapods.org/pods/BikeProvider)

## Description
BikeProvider is a tiny, convenient library for retrieving relevant city bike share information.
Based on the user's location, it uses the citybik.es API to to find the nearest city with bike share availability.
It can then return relevant bike station information such as station location and number of available bikes etc.

The framework was built to accommodate [Bikey](https://itunes.apple.com/ie/app/bikey/id1048962300?mt=8), my free bike share app available on the app store.

## Requirements

Uses CoreLocation to retrieve location.

## Installation

BikeProvider is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "BikeProvider"
```

## Usage

* Import the framework 'import SPBBikeProvider'
* Make a request (nearest city, stations etc.) and consume the response

Simple as that

## Examples

#### Location

```
LocationProvider.sharedInstance.delegate = self
LocationProvider.sharedInstance.getLocation(withAuthScope: .authorizedWhenInUse)
```
...and in the location delegate...
```
func retrieved(location: CLLocation) {
  // Do something with the location here
}
```

#### Nearest city

```
CityProvider.city(near: location, onSuccess: { city in
  // Do something with the city here
}, onFailure: {
  // Oh no, something went wrong
})
```

#### Stations

```
StationProvider.stations(fromCityURL: city.url, onSuccess: { stations in
  // Do something with the stations here
}, onFailure: {
  // Oh no, something went wrong
})

```

See the sample project for fuller examples.

![Sample app screenshot](https://raw.githubusercontent.com/superpeteblaze/SPBBikeProvider/master/Assets/Screenshot.png)

## Author

Pete Smith, peadar81@gmail.com

## License

BikeProvider is available under the MIT license. See the LICENSE file for more info.
