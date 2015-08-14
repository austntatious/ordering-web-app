require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

class GaApi
  def self.get_week_summary
    require 'google/apis/analytics_v3'
    require 'google/api_client/auth/key_utils'

    an = Google::Apis::AnalyticsV3::AnalyticsService.new

    an.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience             => 'https://accounts.google.com/o/oauth2/token',
      :scope                => 'https://www.googleapis.com/auth/analytics.readonly',
      :issuer               => ENV['GOOGLE_SERVICE_EMAIL'],
      :signing_key          => Google::APIClient::KeyUtils.load_from_pkcs12(ENV['GOOGLE_PK'], ENV['GOOGLE_PK_PASSWORD'])
    ).tap { |auth| auth.fetch_access_token! }
    # binding.pry
    # an.authorization.fetch_access_token!

    # api_method = client.discovered_api('analytics','v3').data.ga.get
    data = an.get_ga_data(
      ENV['GOOGLE_ANALYTICS_PROFILE'],
      (Date.today - 1.week).to_s,
      Date.today.to_s,
      'ga:pageviews'
    )
    data


    # # make queries
    # result = client.execute(:api_method => api_method, :parameters => {
    #   'ids'        => ENV['GOOGLE_ANALYTICS_PROFILE'],
    #   'start-date' => (Date.today - 1.week).to_s,
    #   'end-date'   => Date.today.to_s,
    #   # 'dimensions' => 'ga:pagePath',
    #   'metrics'    => 'ga:pageviews'#,
    #   # 'filters'    => 'ga:pagePath==/'
    # })

    # result
  end
end
