require 'google/apis/core/base_service'
require 'google/apis/core/json_representation'
require 'google/apis/core/hashable'
require 'google/apis/errors'
require 'google/apis/analytics_v3'
require 'google/api_client/auth/key_utils'

require 'openssl'
OpenSSL::SSL::VERIFY_PEER = OpenSSL::SSL::VERIFY_NONE

module Google
  module Apis
    module AnalyticsV3
      class AnalyticsService < Google::Apis::Core::BaseService
        def get_ga_data(ids, start_date, end_date, metrics, dimensions, filters: nil, max_results: nil, output: nil, sampling_level: nil, segment: nil, sort: nil, start_index: nil, fields: nil, quota_user: nil, user_ip: nil, options: nil, &block)
          path = 'data/ga'
          command =  make_simple_command(:get, path, options)
          command.response_representation = Google::Apis::AnalyticsV3::GaData::Representation
          command.response_class = Google::Apis::AnalyticsV3::GaData
          command.query['dimensions'] = dimensions unless dimensions.nil?
          command.query['end-date'] = end_date unless end_date.nil?
          command.query['filters'] = filters unless filters.nil?
          command.query['ids'] = ids unless ids.nil?
          command.query['max-results'] = max_results unless max_results.nil?
          command.query['metrics'] = metrics unless metrics.nil?
          command.query['output'] = output unless output.nil?
          command.query['samplingLevel'] = sampling_level unless sampling_level.nil?
          command.query['segment'] = segment unless segment.nil?
          command.query['sort'] = sort unless sort.nil?
          command.query['start-date'] = start_date unless start_date.nil?
          command.query['start-index'] = start_index unless start_index.nil?
          command.query['fields'] = fields unless fields.nil?
          command.query['quotaUser'] = quota_user unless quota_user.nil?
          command.query['userIp'] = user_ip unless user_ip.nil?
          execute_or_queue_command(command, &block)
        end
      end
    end
  end
end

class GaApi
  def self.get_week_summary

    an = Google::Apis::AnalyticsV3::AnalyticsService.new

    an.authorization = Signet::OAuth2::Client.new(
      :token_credential_uri => 'https://accounts.google.com/o/oauth2/token',
      :audience             => 'https://accounts.google.com/o/oauth2/token',
      :scope                => 'https://www.googleapis.com/auth/analytics',
      :issuer               => ENV['GOOGLE_SERVICE_EMAIL'],
      :signing_key          => Google::APIClient::KeyUtils.load_from_pkcs12(ENV['GOOGLE_PK'], ENV['GOOGLE_PK_PASSWORD'])
    ).tap { |auth| auth.fetch_access_token! }

    data = an.get_ga_data(
      ENV['GOOGLE_ANALYTICS_PROFILE'],
      (Date.today - 1.week).to_s,
      Date.today.to_s,
      'ga:pageviews',
      'ga:date'
    )
    data.rows.map { |x| x[1] }
  end
end
