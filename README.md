# SPBBikeProvider

[![CI Status](https://travis-ci.org/superpeteblaze/SPBBikeProvider.svg?branch=master)](https://travis-ci.org/superpeteblaze/SPBBikeProvider)
[![Version](https://img.shields.io/cocoapods/v/SPBBikeProvider.svg?style=flat)](http://cocoapods.org/pods/SPBBikeProvider)
[![License](https://img.shields.io/cocoapods/l/SPBBikeProvider.svg?style=flat)](http://cocoapods.org/pods/SPBBikeProvider)
[![Platform](https://img.shields.io/cocoapods/p/SPBBikeProvider.svg?style=flat)](http://cocoapods.org/pods/SPBBikeProvider)
[![Platform](https://img.shields.io/cocoapods/p/SPBBikeProvider.svg?style=flat)](http://cocoapods.org/pods/SPBBikeProvider)

## Description
SPBBikeProvider is a tiny, convenient framework for retrieving relevant city bike share information.
Based on the user's location, it uses the citybik.es API to to find the nearest city with bike share availability.
It can then return relevant bike station information such as station location and number of available bikes etc.

![Sample app screenshot](https://raw.githubusercontent.com/superpeteblaze/SPBBikeProvider/master/Assets/Screenshot.png)

The framework was built to accommodate [Bikey](https://itunes.apple.com/ie/app/bikey/id1048962300?mt=8), my free bike share app available on the app store.

## Requirements

Uses CoreLocation to retrieve location.

## Installation

SPBBikeProvider is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SPBBikeProvider"
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

## Author

Pete Smith, peadar81@gmail.com

## License

SPBBikeProvider is available under the MIT license. See the LICENSE file for more info.
