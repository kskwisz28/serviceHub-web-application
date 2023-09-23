module Presenters
  class LiteraturesPresenter
    attr_reader :context

    def initialize(context:)
      @context = context
    end

    def instrument
      @instrument ||= build_category(Literature::INSTRUMENT)
    end

    def qualification
      @qualification ||= build_category(Literature::QUALIFICATION)
    end

    def consulting
      @consulting ||= build_category(Literature::CONSULTING)
    end

    def education
      @education ||= build_category(Literature::EDUCATION)
    end

    def promotion
      @promotion ||= build_category(Literature::PROMOTION)
    end
	def restart
      @promotion ||= build_category(Literature::RESTART)
    end
    private

    def build_category(category)
      Literature.where(literature_category: category).map do |literature|
        LiteraturePresenter.new(
          context: context,
          literature: literature,
        )
      end
    end
  end
end
