module ApplicationHelper
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
        "Refferal bonus"
      when AccountTransaction::KIND_ORDER_PAY
        "Payed for order ##{account_transaction.order_id}"
      else
        ""
    end
  end
end
