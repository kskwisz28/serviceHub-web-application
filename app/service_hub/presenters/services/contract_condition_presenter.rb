module Presenters
  module Services
    class ContractConditionPresenter
      include Concerns::FilteredPricesConcern

      attr_reader :context
      attr_reader :prices
      attr_reader :contract_condition

      def initialize(context:, prices:, contract_condition:)
        @context = context
        @prices = prices
        @contract_condition = contract_condition
      end

      def sku
        prices.first.sku
      end

      def description
        contract_condition.condition_title
      end

      def type
        contract_condition.type
      end

      def product_manager
        prices.first.product_manager
      end

      def pricing_condition
        contract_condition.pricing_condition
      end

      def contents
        (contract_condition.public_description.split("///") || ["No further details available"]).reject(&:empty?)
      end
    end
  end
end
