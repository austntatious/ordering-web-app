class Notifier < ActionMailer::Base
  default from: ENV['FROM_EMAIL']

  def notify_payed(order)
    @order = order
    mail to: @order.user.email, subject: "Order #{@order.id} on StreetEats is payed"
  end

  def invite(invite)
    @invite = invite
    mail to: invite.email, subject: "#{invite.user.name} invites you to StreetEats"
  end

  def notify_payed_admin(order)
    @order = order
    mail to: Setting.get('Admin email'), subject: "Order #{@order.id} on StreetEats is payed"
  end

  def notify_created(order)
    @order = order
    mail to: @order.user.email, subject: "Your order on StreetEats is created"
  end

  def notify_created_admin(order)
    @order = order
    mail to: Setting.get('Admin email'), subject: "New order on StreetEats"
  end

  def connect_stripe(restaurant)
    @restaurant = restaurant
    mail to: restaurant.owner_mail, subject: "Connect your Stripe account to StreetEats"
  end
end
