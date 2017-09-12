[![Build Status](https://travis-ci.org/wallee-payment/wallee-ios-sdk.svg?branch=master)](https://travis-ci.org/wallee-payment/wallee-ios-sdk)
[![Maven Central](https://maven-badges.herokuapp.com/maven-central/com.wallee/wallee-ios-sdk/badge.svg)](https://maven-badges.herokuapp.com/maven-central/com.wallee/wallee-ios-sdk)

# wallee-ios-sdk

This project allows to integrate the <a href="https://wallee.com">wallee payment service</a> into
iOS apps.

# Install Dependency

The simplest way to start using wallee API is via cocoapods

<!-- ### CocoaPods

[CocoaPods](http://cocoapods.org) is a dependency manager for Cocoa projects.

To integrate wallee-ios-sdk into your Xcode project using CocoaPods, specify it in your `Podfile`:

```ruby
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

target '<Your Target Name>' do
    pod 'WalleeSDK', '~> 1.0'
end
```

Then, run the following command:

```bash
$ pod install
```
 -->
# Basic Usage

The simplest way to use the SDK is by instantiating a `WALFlowConfigurationBuilder` with a `WALCredentialsFetcher`. 
If you are interested in life cycle events of the payment flow you should adopt the `WALPaymentFlowDelegate` protocol and add yourself as the delegate to the `WALFlowConfigurationBuilder`.

With this a basic configuration is valid and can be used to create a `WALFlowCoordinator`.

Be sure to keep a strong reference to the `WALFlowCoordinator` because the whole payment process is not self contained and terminates once it is not referenced by anyone anymore.

Once you start the payment process by `[WALFlowCoordinator start]` the coordinator pulls all required data automatically via the credentialsFetcher. The payment process itself runs in a view container which the implementing app has to present.
The simplest way to do this is by simply showing it as a modal ViewController.

Receive the view container via the coordinators properties: `coordinator.paymentContainer.viewController`.

The `WALPaymentFlowDelegate` has mandatory delegate methods which are indicating the payment process terminal state.
As in either success or failure.

The `WALCredentialsFetcher` is responsible for fetching the access credentials to the web
service API. The access user ID and the HMAC key of the user need to be stored securely on the
merchant backend server. They cannot be stored within the application. The backend server can
request for a particular transaction temporary credentials which grants temporary access to the
transaction. Those credentials can be forwarded to the app. This way the merchant keeps control
over what the user of the app is allowed to do.

The `WALFlowCoordinator` has generally the following flow:

1) Allow the user to select a token from a list of tokens.
2) When the user wants to use another payment method or if there are not tokens stored for the user
   a list of payment methods is presented.
3) When the user selects a payment method the form for collecting the data (like credit card number)
   is loaded.
4) The form is submitted and the transaction is processed.

This flow can be adapted see the advanced usage section for more information about this.

# Sample App

To run the sample application the easiest way is to checkout the repository and to launch the
`WalleeSDKExample` through `XCode`.

The `sample app` shows how to use the `WALFlowCoordinator` with a default configuration. This is the simplest way to
use the SDK.

To see how to use the `WALFlowCoordinator` the best is to take a look at the sample app.

# Advanced Usage

The SDK is build in layers:

* Credentials Handling: This layer is responsible to provide and manage the credentials.
* API Request Handling: The API request handling allows to interact with the web service API. This
  layer requires the credentials.
* Various Views: There are different views for each of the used screens.
* Flow Coordinator: The flow coordinator binds the API request handling and the views layer together.
  The flow coordinator implies a specific flow as described above.
* Fragments: The fragments we provide simplifies the usage of the flow coordinator.

Each of the above layers can be used as pleased. This implies that an app can use only the web
services and implements the rest by itself or it can also use the different views, but with a
different flow.

# Documentation

For detailed information about wallee API please see [wallee documentation](https://app-wallee.com/doc/api/web-service).