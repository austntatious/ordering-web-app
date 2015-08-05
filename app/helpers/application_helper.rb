module ApplicationHelper
  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column.to_s == sort_column.to_s ? "#{sort_direction}" : ''
    direction = column.to_s == sort_column.to_s && sort_direction == "asc" ? "desc" : "asc"
    link_to "<span>#{title}</span>".html_safe, params.merge(:sort => column, :direction => direction), {:class => css_class}
  end

  def model_errors(model)
    result = ""
    if model.errors.any?
      result = "<div class='alert alert-danger'>#{model.errors.full_messages.join('<br>')}</div>".html_safe
    end
    result
  end

  def promo_image
    pm = Setting::get('Facebook promotional image path')
    if pm.blank?
      unless @restaurant.blank?
        pm = "https://bingstreeteats.com#{@restaurant.img.url}"
      end
    end
    pm
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def bootstrap_class_for flash_type
    case flash_type.to_sym
      when :success
        "alert-success"
      when :error
        "alert-danger"
      when :alert
        "alert-warning"
      when :notice
        "alert-info"
      else
        flash_type.to_s
    end
  end

  def account_transaction_kind(account_transaction)
    case account_transaction.kind
      when AccountTransaction::KIND_REF_BONUS
        "Referral bonus"
      when AccountTransaction::KIND_ORDER_PAY
        "Payed for order ##{account_transaction.order_id}"
      else
        ""
    end
  end

  def twitter_ref_link
    url = u(root_url(:ref_id => current_user.id))
    "http://twitter.com/home/?status=#{u(Setting::get('Facebook invitation text'))} #{url}"
  end

  def facebook_ref_link
    url = u(root_url(:ref_id => current_user.id))
    "https://www.facebook.com/dialog/feed?app_id=#{ENV['FACEBOOK_APP_ID']}&display=page&link=#{url}&redirect_uri=#{root_url}&caption=#{u(Setting::get('Facebook invitation text'))}"
  end

  def order_arrive_from(order)
    m = Setting::get('Order arrive since')
    if m == ''
      m = 35
    else
      m = m.to_i
    end
    order.updated_at + m.minutes
  end

  def order_arrive_to(order)
    m = Setting::get('Order arrive before')
    if m == ''
      m = 55
    else
      m = m.to_i
    end
    order.updated_at + 55.minutes
  end
end
