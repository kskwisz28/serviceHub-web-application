module Presenters
  module Concerns
    module FilteredPricesConcern
      E1_COUNTRIES = [
        "IN",
      ].freeze

      def filtered_prices
        filtered = []
        if context.country.in?(E1_COUNTRIES)
          filtered = prices.reject(&:sap?)
        else
          filtered = prices.select(&:sap?)
        end

        if filtered.empty?
          prices
        else
          filtered
        end
      end
    end
  end
end
