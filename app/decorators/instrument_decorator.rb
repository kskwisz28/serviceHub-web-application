# The purpose of this decorator is to take an instrument with a lot of pricing
# data and return an object that only shows pricing data for the current
# user's role and country

require "active_support/all"

class InstrumentDecorator

  DecoratedInstrument = Struct.new(
    :name,
    :countries,
    :packages,
    :standalone_services,
    :add_on_services,
    :qualification_services,
    :professional_services,
    :maintenance_services,
    :education_services,
    keyword_init: true
  )


  Package = Struct.new(
    :sku,
    :name,
    :price,
    :contents,
    keyword_init: true
  )

  PackageContents = Struct.new(
    :sku,
    :name,
    :quantity,
    :component_type,
    keyword_init: true
  )

  StandaloneService = Struct.new(
    :sku,
    :name,
    :integration_string,
    :price,
    :pricing_condition,
    :pricing_description,
    :contents,
    :contract_type,
    :product_manager,
    keyword_init: true
  )

  QualificationService = Struct.new(
    :sku,
    :name,
    :integration_string,
    :price,
    :pricing_condition,
    :pricing_description,
    :contents,
    :qualification_type,
    :product_manager,
    keyword_init: true
  )

  EducationService = Struct.new(
    :sku,
    :name,
    :integration_string,
    :price,
    :contents,
    :training_course_level,
    :duration,
    :location,
    :division,
    :platform,
    :quantity,
    :product_manager,
    :training_course_type,
    keyword_init: true
  )

  UNKNOWN = 'Unknown'.freeze

  attr_reader :instrument, :country_code, :role

  def initialize(instrument, country_code, role)
    @instrument = instrument
    @country_code = country_code
    @role = role
  end

  def decorate
    if role == 'instrument_sales'
      standalone_services = instrument_sales_standalone_services
      add_on_services = instrument_sales_add_on_services
      education_services = sales_education_services
    else
      standalone_services = service_sales_standalone_services
      add_on_services = service_sales_add_on_services
      education_services = service_education_services
    end

    DecoratedInstrument.new(
      name: instrument.name,
      countries: instrument.countries,
      packages: packages,
      standalone_services: standalone_services,
      add_on_services: add_on_services,
      qualification_services: qualification_services,
      professional_services: professional_services,
      maintenance_services: maintenance_services,
      education_services: education_services
    )
  end

  private

  def packages
    packages = instrument.packages.map do |package|
      unless package[:region] == nil
        current_country = ServiceHub::SupportedCountries.list.select! {|country| country[:code] == country_code }
        current_region = current_country.first[:region]

        if package[:region].include?(current_region) || package[:region].include?("GLOBAL")
          formatted_contents = package[:contents].map do |content|
            PackageContents.new(
              sku: content[:sku],
              name: content[:name],
              quantity: content[:quantity],
              component_type: content[:component_type]
            )
          end

          price_data = package[:prices].find { |p| p[:country] == country_code }
          if price_data
            price = formatted_price(price_data[:price], price_data[:country], price_data[:currency])
            if price
              Package.new(
                sku: package[:sku],
                name: package[:name],
                price: price,
                contents: formatted_contents
              )
            end
          end
        end
      end
    end
    packages.compact.uniq
  end

  def instrument_sales_standalone_services
    decorate_standalone_services(instrument.instrument_sales_standalone_services)
  end

  def service_sales_standalone_services
    decorate_standalone_services(instrument.service_sales_standalone_services)
  end

  def instrument_sales_add_on_services
    decorate_add_on_services(instrument.instrument_sales_add_on_services)
  end

  def service_sales_add_on_services
    decorate_add_on_services(instrument.service_sales_add_on_services)
  end

  def decorate_standalone_services(standalone_service_data)
    standalone_services = standalone_service_data.map do |service|
      if service[:country] == country_code
        generate_service_data(service)
      end
    end
    standalone_services.compact.sort_by(&:sku)
  end

  def decorate_add_on_services(standalone_service_data)
    standalone_services = standalone_service_data.map do |service|
      if service[:country] == country_code
        generate_service_data(service)
      end
    end
    standalone_services.compact.sort_by(&:sku)
  end

  def generate_service_data(service)
    StandaloneService.new(
      sku: service[:sku],
      name: service[:name] || UNKNOWN,
      integration_string: service[:country] == "IN" && pricing_details(service[:country], service[:integration_id]),
      price: formatted_price(service[:price], service[:country], service[:currency]),
      pricing_condition: service[:pricing_condition],
      pricing_description: service[:pricing_description],
      contents: service[:contents] || UNKNOWN,
      product_manager: service[:product_manager],
      contract_type: service[:contract_type] || UNKNOWN
    )
  end

  def qualification_services
    decorate_qualifications(instrument.qualification_services)
  end

  def professional_services
    decorate_qualifications(instrument.professional_services)
  end

  def maintenance_services
    decorate_qualifications(instrument.maintenance_services)
  end

  def decorate_qualifications(qualifications)
    quals = qualifications.map do |service|
      price_data = service[:prices].find { |p| p[:country] == country_code }

      if price_data
        price = formatted_price(price_data[:price], price_data[:country], price_data[:currency])
        pricing_condition = price_data[:pricing_condition]
        pricing_description = price_data[:pricing_description]
        product_manager = price_data[:product_manager]

        QualificationService.new(
          sku: service[:sku],
          name: service[:name],
          qualification_type: service[:qualification_type],
          contents: service[:contents] || UNKNOWN,
          price: price,
          integration_string: price_data[:country] == "IN" && pricing_details(price_data[:country], price_data[:integration_id]),
          pricing_condition: pricing_condition || UNKNOWN,
          pricing_description: pricing_description || UNKNOWN,
          product_manager: product_manager || UNKNOWN,
        )
      end
    end

    quals.compact.sort_by(&:sku)
  end

  def sales_education_services
    education_services(instrument.sales_education_services)
  end

  def service_education_services
    education_services(instrument.service_education_services)
  end

  def education_services(services)
    ed_services = []
    services = services || []
    services.each do |service|
      price_data = service[:prices].find { |p| p[:country] == country_code }

      if price_data
        price = formatted_price(price_data[:price], price_data[:country], price_data[:currency])
        product_manager = price_data[:product_manager]

        ed_service = EducationService.new(
          sku: service[:sku],
          name: service[:name] || UNKNOWN,
          price: price,
          integration_string: price_data[:country] == "IN" && pricing_details(price_data[:country], price_data[:integration_id]),
          product_manager: product_manager || UNKNOWN,
          training_course_level: service[:training_course_level],
          contents: service[:contents] || UNKNOWN,
          duration: service[:duration],
          location: service[:location],
          division: service[:division],
          quantity: service[:quantity],
          platform: service[:platform],
          training_course_type: service[:training_course_type] || UNKNOWN,
        )
        ed_services << ed_service
      end


    end
    ed_services.sort_by(&:sku)
  end

  def formatted_integration_id(integration_id)
    integration_id.strip.delete('/')
  end

  def pricing_details(country_code, integration_id)
    country_pricing = (ServiceHub::SupportedCountries.list.find(-> { {} }) { |country| country[:code] == country_code }[:pricing] || {}).stringify_keys

    country_pricing[formatted_integration_id(integration_id)]
  end

  def formatted_price(raw_price, country_code, currency)
    return unless raw_price.to_f

    if currency.present?
      currency_symbol = Money::Currency.find(currency).symbol
      "#{currency} #{ActiveSupport::NumberHelper::number_to_currency(raw_price.to_f, unit: currency_symbol)}"
    else
      country = ISO3166::Country[country_code]
      if country.present?
        currency_symbol = country.currency.symbol
        ActiveSupport::NumberHelper::number_to_currency(raw_price.to_f, unit: currency_symbol)
      end
    end
  end
end
