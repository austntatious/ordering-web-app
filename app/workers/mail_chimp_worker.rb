require 'mailchimp'

class MailChimpWorker
  include Sidekiq::Worker

  def perform(order_id)
    order = Order.find_by_id(invite_id)
    unless order.nil?
      begin
        mailchimp = Mailchimp::API.new(ENV['MAILCHIMP_API_KEY'])
        mailchimp.lists.batch_subscribe(ENV['MAILCHIMP_LIST_ID'],  [{
          'EMAIL' => { 'email' => order.user.email, },
          :merge_vars => { "FIRSTNAME" => order.contact_name, "STATUS" => "Subscribed" }
        }], false)
      rescue
      end
    end
  end
end
