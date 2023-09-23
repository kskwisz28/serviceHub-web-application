module InstrumentHelper

  # Would have liked to simple have the controller render the decorated instrumnet
  # But Rails wants an AR-compatible object in order to navigate through all the partials.
  def decorated_instrument(instrument)
    @decorated_instrument ||= InstrumentDecorator.new(instrument, current_user.country_code, current_user.role).decorate
  end

  def all_services(instrument)
    services = [
      decorated_instrument(instrument).standalone_services,
      decorated_instrument(instrument).add_on_services,
      decorated_instrument(instrument).qualification_services,
      decorated_instrument(instrument).education_services,
      decorated_instrument(instrument).professional_services,
      decorated_instrument(instrument).maintenance_services
    ]

    services.reject(&:empty?).flatten
  end

  def image_uri(model)
    "instruments/#{model}.jpg"
  end

  def fallback_image_uri(model)
    "instruments/#{model.gsub("/", '-')}.jpg"
  end

  def integration_id_name(integration_id)
    {
      "AB_S1_USD" => "Dealer/Distributor",
      "AB_T1_USD" => "End customer",
      "IN/B" => "Before Duties",
      "IN/DP" => "Duties Paid",
      "IN/SGUSD" => "Before Duties",
      "AB_IN_INR" => "Duties Paid",
      "AB_IN_USD" => "Before Duties",
    }.fetch(integration_id, integration_id)
  end

  def format_price(price, prices)
    str = format_single_price(price)
    str += ": #{integration_id_name(price.integration_id)}" if prices.many?
    str
  end

  def format_single_price(price)
    if price.currency.present?
      currency_symbol = Money::Currency.find(price.currency).symbol
      "#{price.currency} #{ActiveSupport::NumberHelper::number_to_currency(price.amount.to_f, unit: currency_symbol)}"
    else
      country = ISO3166::Country[price.country]
      if country.present?
        currency_symbol = country.currency.symbol
        ActiveSupport::NumberHelper::number_to_currency(price.amount.to_f, unit: currency_symbol)
      end
    end
  end
end
