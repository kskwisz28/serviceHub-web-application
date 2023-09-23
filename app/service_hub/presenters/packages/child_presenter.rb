module Presenters
  module Packages
    class ChildPresenter
      attr_reader :package
      attr_reader :context
      attr_reader :contract_condition

      def initialize(package:, context:, contract_condition:)
        @package = package
        @context = context
        @contract_condition = contract_condition
      end

      def sku
        package.component_sku
      end

      def description
        package.component_description
      end

      def quantity
        package.pkg_qty
      end

      def component_type
        package.component_type
      end

      def contents
        (contract_condition&.public_description&.split("///") || ["No further details available"]).reject(&:empty?)
      end
    end
  end
end
