# FVCustomAlertView-Swift

Custom AlertView for iOS SDK. Port from [FVCustomAlertView](https://github.com/thegameg/FVCustomAlertView)

## Usage

To run the example project, clone the repo, open `FVCustomAlertView-Swift.xcworkspace`

## Requirements

* iOS7+ project
* ARC project

## Difference from FVCustomAlertView

* Remove blur to support iOS7, you can use the objective version to get that
* Add a thread-safe share singleton

## How to install FVCustomAlertView

Not have enough time, so only manual way now.

Copy the source file and resource images to your project

* FVCustomAlertView.swift
* FVCustomAlertViewResources/

## How to use FVCustomAlertView

Use `FVCustomAlertView.shareInstance`, it's a thread-saft singleton.

It comes with 4 default modes and a cutom mode.

The default modes are : (make sure you try them in the example app)

* Loading

```swift
FVCustomAlertView.shareInstance.showDefaultLoadingAlertOnView(self.view, withTitle: "Loading...")
```

* Done

```swift
FVCustomAlertView.shareInstance.showDefaultDoneAlertOnView(self.view, withTitle: "Done")
```

* Error

```swift
FVCustomAlertView.shareInstance.showDefaultErrorAlertOnView(self.view, withTitle: "Error")
```

* Warning

```swift
FVCustomAlertView.shareInstance.showDefaultWarningAlertOnView(self.view, withTitle: "Be careful")
```

* Custom


Sorry, I do not add that in the example project, but it's supported!!!

## Author

Garnel Mao
maogm12 [AT] gmail.com
maogm.com

## License

This code is distributed under the terms and conditions of the [MIT license](LICENSE).