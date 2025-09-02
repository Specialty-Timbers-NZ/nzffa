class CreateOrder
  def self.from_subscription(subscription)
    new(subscription).create_order
  end

  def self.upgrade_subscription(params)
    old_sub = params[:from]
    new_sub = params[:to]
    old_order = old_sub.order

    raise "old subscription is not paid yet. cannot upgrade" unless old_sub.paid?

    order = new(new_sub).create_order
    order.old_subscription = old_sub
    @subscription = new_sub

    fraction_used = CalculatesSubscriptionLevy.fraction_used(old_sub.begins_on, old_sub.expires_on)

    old_order.refundable_order_lines.each do |line|
      next if line.amount == 0
      order.add_refund(kind: line.kind,
                       particular: line.particular,
                       amount: line.refund_amount(fraction_used))
    end

    order.remove_cancelling_order_lines!
    order
  end

  def initialize(subscription)
    @subscription = subscription
  end

  attr_accessor :subscription
  delegate :reader, :to => :subscription

  def create_order
    order = Order.new
    order.add_charge(kind: 'admin_levy',
                     particular: "Admin Levy",
                     amount: admin_levy_amount)
    order.add_charge(kind: 'business_size_levy',
                     particular: subscription.business_size,
                     amount: business_size_levy_amount)
    if subscription.belongs_to_fft
      order.add_charge(kind: 'fft_marketplace_levy',
                       particular: 'fft_membership',
                       amount: fft_marketplace_levy_amount)
    end

    order.subscription = subscription
    order.amount = order.order_lines.map{|ol| ol.amount}.sum
    order
  end

  def fft_marketplace_levy_amount
    subscription.length_in_years *
      StnzSettings.fft_marketplace_levy.to_i
  end

  def business_size_levy_amount
    subscription.length_in_years *
      StnzSettings.business_size_levys[subscription.business_size].to_i
  end

  def admin_levy_amount
    if reader.is_branch_life_member? or reader.is_life_member?
      0
    else
      @subscription.length_in_years * StnzSettings.admin_levy.to_i
    end
  end

end
