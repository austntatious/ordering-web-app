require 'twilio-ruby'

class SmsApi
  def self.send_sms(to, text)
    unless to.blank?
      unless text.blank?
        client = Twilio::REST::Client.new ENV['TWILIO_ACCOUNT_SID'], ENV['TWILIO_AUTH_TOKEN']

        begin
          client.account.messages.create(
            :from => ENV['TWILIO_PHONE_NUMBER'],
            :to => to,
            :body => text
          )
        rescue
        end
      end
    end
  end
end
