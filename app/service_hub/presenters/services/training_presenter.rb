module Presenters
  module Services
    class TrainingPresenter
      include Concerns::FilteredPricesConcern

      attr_reader :context
      attr_reader :prices
      attr_reader :training

      def initialize(context:, prices:, training:)
        @context = context
        @prices = prices
        @training = training
      end

      def sku
        prices.first.sku
      end

      def description
        training.sku_name
      end

      def type
        training.course_type
      end

      def level
        training.course_level
      end

      def location
        training.course_location
      end

      def duration
        training.duration
      end

      def division
        training.division
      end

      def quantity
        training.quantity
      end

      def platform
        training.platform
      end

      def contents
        training.public_course_description
      end
    end
  end
end
