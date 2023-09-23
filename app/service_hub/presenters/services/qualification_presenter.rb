module Presenters
  module Services
    class QualificationPresenter
      include Concerns::FilteredPricesConcern

      attr_reader :context
      attr_reader :prices
      attr_reader :qualification

      def initialize(context:, prices:, qualification:)
        @context = context
        @prices = prices
        @qualification = qualification
      end

      def sku
        qualification.sku_nbr
      end

      def description
        qualification.sku_description
      end

      def contents
        qualification.public_description
      end

      def type
        qualification.type
      end

      def pricing_condition
        prices.first.pricing_condition
      end

      def product_manager
        prices.first.product_manager
      end
    end
  end
end
