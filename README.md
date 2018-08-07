
# Fastlane VersionBox Auto Version Deployment Plugin


## HOW TO USE?


1. Copy this file into your fastlane/actions directory
 2. Add "gem 'json'" to your Gemfile if not exists already
3. Navigate to your Fastfile
4. Make the call "versionbox_deploy" whenever you desire
5. Program will ask your VersionBox app_key, api_token and also the (local) file path of the builded APK/IPA on fastlane run.
6. Optionally you can send parameters when you make the call from Fastfile, for example:
    versionbox_deploy(vb_app_key: "aaaaaaaaa", vb_api_token: "bbbbbbb", vb_file_path: "Build/demo.ipa", vb_version_description:"Example Text")
    - Sending app_key, api_token and file_path this way will prevent application from asking you every time
7. Enjoy your automated version deploy.



## FACTS
1. VersionBox will read the version number from generated apk/ipa
2. File path can be absolute or relative, but make sure versionbox_deploy.rb has access to it.
3. You can use this library both for android and ios apps.
4. Current version won't overwrite existing version with same version number on VersionBox.



## Problems or feedback? Contact Us:
   hello@loopdigital.io
   https://loopdigital.io
   https://github.com/loopdigital

   Loop Digital Inc, NYC, USA
