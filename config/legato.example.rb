require 'google/api_client'
require 'oauth2'
require 'legato'

@key_file = File.expand_path("../../config/ga-privatekey.p12", __FILE__)
@ga_address = "email_from_google_api_dashboard"

def service_account_user(scope="https://www.googleapis.com/auth/analytics.readonly")
   client = Google::APIClient.new(:application_name => "console_analytics")
   key = Google::APIClient::PKCS12.load_key(@key_file,"notasecret")
   service_account = Google::APIClient::JWTAsserter.new(@ga_address, scope, key)
   client.authorization = service_account.authorize
   oauth_client = OAuth2::Client.new("", "", {
      :authorize_url => 'https://accounts.google.com/o/oauth2/auth',
      :token_url => 'https://accounts.google.com/o/oauth2/token'
   })
   token = OAuth2::AccessToken.new(oauth_client, client.authorization.access_token)
   Legato::User.new(token)
end
