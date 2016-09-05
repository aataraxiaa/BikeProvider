# SPBBikeProvider

[![CI Status](https://travis-ci.org/superpeteblaze/SPBBikeProvider.svg?branch=master)](https://travis-ci.org/superpeteblaze/SPBBikeProvider)
[![Version](https://img.shields.io/cocoapods/v/SPBBikeProvider.svg?style=flat)](http://cocoapods.org/pods/SPBBikeProvider)
[![License](https://img.shields.io/cocoapods/l/SPBBikeProvider.svg?style=flat)](http://cocoapods.org/pods/SPBBikeProvider)
[![Platform](https://img.shields.io/cocoapods/p/SPBBikeProvider.svg?style=flat)](http://cocoapods.org/pods/SPBBikeProvider)

## Description
SPBBikeProvider is a tiny, convenient framework for fetching city bike share information.
It uses the citybik.es API and the users location to fetch the nearest available city and
bike station information.

The framework was built to accommodate Bikey, my bike share app available on the app store.

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

#### Nearest city

#### Stations

See the sample project for fuller examples.

## Author

Pete Smith, peadar81@gmail.com

## License

SPBBikeProvider is available under the MIT license. See the LICENSE file for more info.
