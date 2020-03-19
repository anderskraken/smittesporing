fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew cask install fastlane`

# Available Actions
## iOS
### ios upload_appcenter
```
fastlane ios upload_appcenter
```
Upload version to AppCenter
### ios match_enterprise
```
fastlane ios match_enterprise
```
Download and install enterprise certificates
### ios match_development
```
fastlane ios match_development
```
Download and install enterprise certificates
### ios match_appstore
```
fastlane ios match_appstore
```
Download and install enterprise certificates
### ios certificates
```
fastlane ios certificates
```
Download and install certificates
### ios cultivate
```
fastlane ios cultivate
```
Cultivate xcconfig with secret values

----

This README.md is auto-generated and will be re-generated every time [fastlane](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
