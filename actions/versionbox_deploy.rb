#
# Fastlane VersionBox Auto Version Deployment Plugin
# @company: Loop Digital
# @date:    2018
# @author:  Furkan Enes Apaydın (@feapaydin)
#
# https://versionbox.io
# https://github.com/loopdigital
#



### HOW TO USE? ####
#
# 1. Copy this file into your fastlane/actions directory
# 2. Add "gem 'json'" to your Gemfile if not exists already
# 3. Navigate to your Fastfile
# 4. Make the call "versionbox_deploy" whenever you desire
# 5. Program will ask your VersionBox app_key, api_token and also the (local) file path of the builded APK/IPA on fastlane run.
# 6. Optionally you can send parameters when you make the call from Fastfile, for example:
#       versionbox_deploy(vb_app_key: "aaaaaaaaa", vb_api_token: "bbbbbbb", vb_file_path: "Build/demo.ipa", vb_version_description:"Example Text")
#       - Sending app_key, api_token and file_path this way will prevent application from asking you every time
# 7. Enjoy your automated version deploy.
#


### FACTS ####
# 1. VersionBox will read the version number from generated apk/ipa
# 2. File path can be absolute or relative, but make sure versionbox_deploy.rb has access to it.
# 3. You can use this library both for android and ios apps.
# 4. Current version won't overwrite existing version with same version number on VersionBox.


#
# Problems or feedback? Contact Us:
#   hello@loopdigital.io
#   https://loopdigital.io
#   https://github.com/loopdigital
#
#   Loop Digital Inc, NYC, USA
#


require 'json'

module Fastlane
  module Actions
    module SharedValues
      
    end

    class VersionboxDeployAction < Action
      def self.run(params)
       
        #Get params
        api_token=params[:vb_api_token]
        app_key=params[:vb_app_key]
        file_path=params[:vb_file_path]
        description=params[:vb_version_description]


        #VersionBox External API Base
        api_base="http://versionbox.io/api/e/v1"


        #Start Upload
        UI.message "File upload in progress..."

        #
        # VersionBox External API: /UploadVersion
        # https://versionbox.io/api/e/v1/UploadVersion
        #   - file @file
        #   - api_token string
        #   - app_key string
        #   - version_description string optional
        #

        #Upload with CURL
        sent=%x"curl -s -F 'file=@#{file_path}' -F app_key=#{app_key} -F api_token=#{api_token} -F version_description='#{description}' #{api_base}/UploadVersion"
        
        #Get response as JSON
        data=JSON.parse(sent)

        #Work response
        if data["status"]==true

          #Success
          UI.success "VersionBox Upload Success!"

          version=data["data"]["version"]
          UI.message "App Version: #{version["no"]}"

          #Done
          UI.success "### VersionBox Deployment Done. ###"

        else
          #Error
          UI.user_error! "#{data["error_message"]}"
        end


        #RESCUE
        rescue JSON::ParserError => e
          UI.error "Could not retrieve data from VersionBox."
        
        rescue => e
          UI.error "An error occured: #{e}"


        #Thats It! Enjoy.

      end

  

      def self.description
        "Deploy your generated IPA/APK file to VersionBox."
      end

      def self.details
        
        "Submit your generated IPA/APK file to VersionBox as an application version."
      end

      def self.available_options
       
        [
          FastlaneCore::ConfigItem.new(key: :vb_api_token,
                                      env_name: "FL_VERSIONBOX_DEPLOY_API_TOKEN", 
                                      description: "User API Token for Versionbox", 
                                      verify_block: proc do |value|
                                        UI.user_error!("Please enter a valid api token.") unless (value and not value.empty?)

                                      end),
          FastlaneCore::ConfigItem.new(key: :vb_app_key,
                                      env_name: "FL_VERSIONBOX_DEPLOY_APP_KEY", 
                                      description: "Application Key from VersionBox App", 
                                      verify_block: proc do |value|
                                        UI.user_error!("Please enter a valid app key.") unless (value and not value.empty?)
                                      end),
          FastlaneCore::ConfigItem.new(key: :vb_file_path,
                                      env_name: "FL_VERSIONBOX_DEPLOY_FILE_PATH", 
                                      description: "Local PATH to APK or IPA File", 
                                      verify_block: proc do |value|
                                        UI.user_error!("Please enter a valid path.") unless (value and not value.empty?)
                                        UI.user_error!("Cannot find the specified file.") unless File.exists?(value)

                                        extension=value.split(".")
                                        extension=extension[extension.size-1]
                                        extension=extension.downcase

                                        UI.user_error!("The has to be an IPA or APK!") unless (extension=="ipa" || extension=="apk")

                                      end),
            FastlaneCore::ConfigItem.new(key: :vb_version_description,
                                        env_name: "FL_VERSIONBOX_DEPLOY_VERSION_DESCRIPTION", 
                                        description: "Version Description to display on VersionBox"
                                       )
         
        ]
      end

      def self.output
       
      end

      def self.return_value
       
      end

      def self.authors
        ["loopdigital","feapaydin"]
      end

      def self.is_supported?(platform)
        platform == [:ios, :android]
      end
    end
  end
end
