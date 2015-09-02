require 'ga_api'

class Admin::DashboardController < AdminController
  def index
    tw = Order.payed.where('created_at >= ?', DateTime.now - 1.week)
    pw = Order.payed.where('created_at >= ? AND created_at <= ?', DateTime.now - 2.week, DateTime.now - 1.weeks)
    @stats = {
      this_week: tw.map { |o| o.total_price }.sum,
      prev_week: pw.map { |o| o.total_price }.sum,
      orders_week: tw.length,
      order_prev_week: pw.length,
      order_this_week: [],
      sums_this_week: [],
      restaurants: Restaurant.joins(:orders).where('orders.status = ? AND orders.created_at > ?', 'payed', DateTime.now - 1.week).group('restaurants.id').order('SUM(total_order_sum)'),
      orders: Order.order('created_at DESC').limit(10)
    }
    for i in 0..7
      @stats[:order_this_week] << Order.where('DATE(created_at) = ?', Date.today - i.days).count
    end
    for i in 0..7
      @stats[:sums_this_week] << Order.where('DATE(created_at) = ?', Date.today - i.days).map { |o| o.total_sum }.sum
    end
    @stats[:order_this_week].reverse!
    @stats[:sums_this_week].reverse!
  end

  def ga
    respond_to do |format|
      format.json { render :json => GaApi.get_week_summary }
    end
  end

  def add_ctl_breadcrumb
    add_breadcrumb 'Dashboard', admin_dashboard_path
  end
end
