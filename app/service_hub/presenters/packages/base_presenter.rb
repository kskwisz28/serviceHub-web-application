module Presenters
  module Packages
    class BasePresenter
      include Concerns::FilteredPricesConcern

      attr_reader :context
      attr_reader :package
      attr_reader :prices

      def initialize(package:, context:, prices:)
        @package = package
        @context = context
        @prices = prices
      end

      def sku
        package.pkg_sku
      end

      def description
        package.pkg_parent_description
      end

      def children
        @children ||= package.packages.children.preload(:contract_conditions).map do |package|
          ChildPresenter.new(
            context: context,
            package: package,
            contract_condition: package.contract_conditions.first,
          )
        end
      end
    end
  end
end
