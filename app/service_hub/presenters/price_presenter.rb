module Presenters
  class PricePresenter
    attr_reader :price
    attr_reader :context

    def initialize(price:, context:)
      @price = price
      @context = context
    end

    def sku
      price.cleansku
    end

    def description
      price.pricing_condition_description
    end

    def amount
      price.ty_list_price
    end

    def currency
      price.currency
    end

    def country
      price.country
    end

    def integration_id
      price.integration_id
    end

    def pricing_condition
      price.pricing_condition
    end

    def product_manager
      price.product_manager
    end

    def sap?
      price.source == Price::SAP
    end
  end
end
