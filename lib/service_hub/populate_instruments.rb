module ServiceHub
  class PopulateInstruments
    include ActionView::Helpers::NumberHelper

    def run
      begin
        start_time = Time.now
        count = 0
        # Generating this array avoids this error
        # Mongo::Error::OperationFailure: cursor id not found.
        # It appears when querying goes on more than 10 min.
        # Typically, you'd use the no_timeout method (e.g. Model.all.no_timeout)
        # to avoid this but this apps uns on Mongo Atlas, which doesn't allow.
        model_data = Model.all.map do |model|
          { name: model.model, description: model.public_description }
        end

        model_data.each do |data|
          count += 1
          generate_instrument(data[:name], data[:description], count)
        end

        remove_unwanted_instruments

        log_time_spend(start_time, Time.now)
      rescue StandardError => error
        time_of_death = log_time_spend(start_time, Time.now)
        p "Error encountered after #{time_of_death} of runtime."
        p error
      end
    end

    private

    def generate_instrument(model_name, description, count)
      puts "Generating instrument #{model_name}, #{count} of 411"
      instrument = Instrument.where(model: model_name).first

      instrument_sales_standalone_services = generate_standalone_services(model_name, "Instrument Sales")
      qualification_services = generate_qualification_services(model_name)

      attrs = {
        model: model_name,
        name: description,
        countries: generate_country_list(instrument_sales_standalone_services, qualification_services),
        packages: generate_packages(model_name),
        instrument_sales_standalone_services: instrument_sales_standalone_services,
        instrument_sales_add_on_services: generate_add_on_services(model_name, "Instrument Sales"),
        service_sales_standalone_services: generate_standalone_services(model_name, "Service Sales"),
        service_sales_add_on_services: generate_add_on_services(model_name, "Service Sales"),
        qualification_services: qualification_services,
        professional_services: generate_professional_services(model_name),
        maintenance_services: generate_maintenance_services(model_name),
        sales_education_services: generate_trainings(model_name, "InstrumentSales"),
        service_education_services: generate_trainings(model_name, "ServiceSales"),
      }

      if instrument
        puts "Updating #{model_name}"
        instrument.update_attributes!(attrs)
      else
        puts "Creating #{model_name}"
        instrument = Instrument.create!(attrs)
      end
    end

    # If we have any standalone services and/or qualification services, we'll show the instrument.
    def generate_country_list(services, qualification_services)
      puts "Generating country list"
      standalone_services = services.map { |price| price[:country] }.uniq
      qual_countries = []
      qualification_services.each do |qualification_service|
        qual_countries += qualification_service[:prices].map { |p| p[:country] }
      end

      (standalone_services + qual_countries).uniq
    end

    # Packages is a grouping of services and contract
    def generate_packages(model_name)
      puts "Generating packages for #{model_name}"
      packages = Package.all.select {|pkg| pkg.model == model_name }.map do |package|
        prices = package.prices(countries).map do |price|
          {
            price: price.ty_list_price,
            integration_id: price.integration_id,
            currency: price.currency,
            country: price.country
          }
        end

        if prices.any?
          {
            sku: package.pkg_sku,
            name: package.pkg_parent_description,
            prices: prices,
            region: package.region,
            contents: package.package_contents
          }
        end
      end

      packages.compact.uniq
    end

    def generate_standalone_services(model_name, role)
      puts "Generating standalone services for #{model_name}"
      generate_standalone_or_add_on_services(model_name, role, "Contract")
    end

    def generate_add_on_services(model_name, role)
      puts "Generating add-on services for #{model_name}"
      generate_standalone_or_add_on_services(model_name, role, "Contract Add-on")
    end

    def generate_standalone_or_add_on_services(model_name, role, pricing_condition_type)
      services = []

      prices = prices_by_country(model_name)

      prices.each do |price|
        pricing_condition = price.pricing_condition

        contract_conditions = ContractCondition.where(
          pricing_condition: pricing_condition,
          type: pricing_condition_type,
          audience: role
        )

        contract_conditions.each do |contract_condition|
          if contract_condition.present? && price_displayable?(price.ty_list_price)
            attrs = {
              sku: price.cleansku,
              price: price.ty_list_price,
              integration_id: price.integration_id,
              currency: price.currency,
              country: price.country,
              contract_condition: contract_condition.audience,
              product_manager: price.product_manager,
              pricing_condition: pricing_condition,
              name: contract_condition.condition_title,
              contract_type: contract_condition.type,
              contents: contract_condition.public_description.split('///').select{ |str| !str.empty? },
              pricing_description: price.pricing_condition_description
            }
            services << attrs
          end
        end
      end

      services.uniq
    end

    def generate_trainings(model_name, role)
      puts "Generating trainings for #{model_name}"
      trainings = Training.and(Training.or(model: "ALL").or(model: model_name))
                          .and(Training.or(audience: "All").or(audience: role))

      trainings.map do |training|
        sku = training.sku_nbr
        {
          sku: sku,
          name: training.public_course_name || training.sku_name,
          training_course_type: training.course_type,
          prices: prices_from_sku(training.prices(countries), sku),
          contents: training.public_course_description,
          training_course_level: training.course_level,
          quantity: training.quantity,
          duration: training.duration,
          location: training.try(:course_location),
          division: training.division,
          platform: training.platform,
          audience: training.audience
        }
      end
    end

    def generate_qualification_services(model_name)
      puts "Generating qualification services for #{model_name}"
      generate_qualifications(model_name, "Qualification Services")
    end

    def generate_professional_services(model_name)
      puts "Generating professional services for #{model_name}"
      generate_qualifications(model_name, "Professional Services")
    end

    def generate_maintenance_services(model_name)
      puts "Generating maintenance services #{model_name}"
      generate_qualifications(model_name, "Planned Maintenance")
    end

    def generate_qualifications(model_name, category)
      puts "Generating qualifications for #{model_name}"
      Qualification.where(model: model_name, category: category).map do |qualification|
        sku = qualification.sku_nbr
        {
          sku: sku,
          name: qualification.sku_description,
          qualification_type: qualification.type,
          prices: prices_from_sku(qualification.prices(countries), sku),
          contents: qualification.public_description,
        }
      end
    end

    def prices_from_sku(prices, sku)
      prices_for_sku = prices.where(cleansku: sku).map do |price|

        pricing_condition = price.pricing_condition
        contract_condition = ContractCondition.where(pricing_condition: pricing_condition).first
        list_price = price.ty_list_price

        if price_displayable?(list_price)
          {
            price: list_price,
            integration_id: price.integration_id,
            currency: price.currency,
            country: price.country,
            product_manager: price.product_manager,
            pricing_condition: pricing_condition,
            pricing_description: price.pricing_condition_description,
            contract_type: contract_condition.try(:type),
            contents: contract_condition.try(:public_description)
          }
        end
      end

      prices_for_sku.compact
    end

    def countries
      @countries ||= ServiceHub::SupportedCountries.list.map {|c| c[:code].upcase }
    end

    def log_time_spend(start_time, end_time)
      total_time = (end_time - start_time)
      seconds_to_hms(total_time)
    end

    def seconds_to_hms(sec)
      "%02d:%02d:%02d" % [sec / 3600, sec / 60 % 60, sec % 60]
    end

    # Not sure why but there are plenty of price that are $0.01 or $1.  We ignore those.
    def price_displayable?(price)
      price && price.to_f > 1
    end

    def prices_by_country(model_name)
      prices = []

      price = Price.where(:model_official => model_name, :source => 'SAP', :country.in => countries)
      price.present? || price = Price.where(:model_official => model_name, :source => 'E1', :country.in => countries)

      prices << price.to_a
      prices.flatten
    end

    def remove_unwanted_instruments
      models = Model.all.map(&:model)
      instruments = Instrument.all.map(&:model)
      instruments_to_remove = instruments - models
      instruments_to_remove.each do |instrument_model|
        Instrument.find_by(model: instrument_model).destroy
      end
    end

  end
end