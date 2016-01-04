require 'mailchimp'

class MailChimpWorker
  include Sidekiq::Worker

  def perform(order_id)
    # save email in mailchimp
    order = Order.find_by_id(order_id)
    unless order.nil?
      begin
        mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
        mailchimp.lists.batch_subscribe(ENV['MAILCHIMP_LIST_ID'],  [{
          'EMAIL' => { 'email' => order.user_email, },
          :merge_vars => { "FIRSTNAME" => order.contact_name, "STATUS" => "Subscribed" }
        }], false)
      rescue
      end
    end
  end
end
