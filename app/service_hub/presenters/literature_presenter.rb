module Presenters
  class LiteraturePresenter
    attr_reader :context
    attr_reader :literature

    def initialize(context:, literature:)
      @context = context
      @literature = literature
    end

    def title
      literature.public_title
    end

    def type
      literature.literature_type
    end

    def region
      literature.region
    end

    def url
      literature.asset_url
    end
  end
end
