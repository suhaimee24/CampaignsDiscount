class CampaignsController < ApplicationController

  def create
    # orders = ["coupon"]
    items = params_campaigns['items'].to_a || []
    campaigns = params_campaigns['campaigns'].to_a || []
    points = params_campaigns['points'].to_i || 0
    campaigns = campaigns.each_with_object({}) { |item, obj| obj[item["category"].to_s] = item }
    discont = []
    total_price = items.sum { |h| h[:amount].to_i * h[:price].to_i }

    # Category Coupon
    if campaigns["coupon"].present?
      coupon = campaigns["coupon"]
      if coupon['amount'].to_s.include? '%'
        percentage = coupon['amount'].gsub('%', '').to_f/100
        discont_price = total_price * percentage
      else
        discont_price = coupon['amount'].to_i
      end
      discont.push(
        {
          label: coupon['label'],
          discont_price: discont_price
        }
      )
      total_price -= discont_price
    end

    # Category On top
    if campaigns["on_top"].present?
      coupon = campaigns["on_top"]
      if coupon["items_category"].present?
        selected_item = items.select { |item| item["category"] == coupon["items_category"] }
        total_price_item = selected_item.sum { |h| h[:amount].to_i * h[:price].to_i }
        if coupon['amount'].to_s.include? '%'
          percentage = coupon['amount'].gsub('%', '').to_f/100
          discont_price = total_price_item * percentage
        else
          discont_price = selected_item.count * coupon['amount'].to_i
        end
      else
        ['points'].each do |param|
          return render_bad_request(message: "#{param} is required.") if params_campaigns[param].blank?
        end
        discont_price = [points, total_price * 0.2].min
      end
      discont.push(
        {
          label: coupon['label'],
          discont_price: discont_price
        }
      )
      total_price -= discont_price
    end

    # Category Seasonal
    if campaigns["seasonal"].present?
      coupon = campaigns["seasonal"]
      ['every', 'amount'].each do |param|
        return render_bad_request(message: "#{param} is required.") if coupon[param].blank?
      end
      discont_price = (total_price / coupon["every"].to_i) * coupon["amount"].to_i
      discont.push(
        {
          label: coupon['label'] % [coupon["amount"],coupon["every"].to_i],
          discont_price: discont_price
        }
      )
      total_price -= discont_price
    end

    return render_ok({total_price:, items:, discont:})
  end

  private

  def params_campaigns
    params.permit(
    :points,
    items: [
      :name,
      :category,
      :price,
      :amount,
    ],
    campaigns: [
      :category,
      :name,
      :label,
      :items_category,
      :amount,
      :every,
    ]
   )
  end

end
