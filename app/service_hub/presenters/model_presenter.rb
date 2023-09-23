module Presenters
  class ModelPresenter
    attr_reader :model
    attr_reader :context

    def initialize(model:, context:)
      @model = model
      @context = context
    end

    def id
      model.model
    end

    def description
      model.public_description
    end
	def status
      model.status
    end
	def skus
      model.skus
    end
    def packages?
      context.audience == User::INSTRUMENT
    end

    def packages
      @packages ||= model.package_prices.where(prices: { country: context.country }).preload(:package).group_by(&:package).map do |package, prices|
        Packages::BasePresenter.new(
          context: context,
          package: package,
          prices: prices.map { |p| PricePresenter.new(price: p, context: context) },
        )
      end
    end

    def standalones
      @standalones ||= contract_condition_services(ContractCondition::STANDALONE)
    end

    def addons
      @addons ||= contract_condition_services(ContractCondition::ADDON)
    end

    def qualification_qualifications
      @qualification_qualifications ||= qualification_services(Qualification::QUALIFICATION)
    end

    def qualification_professionals
      @qualification_professionals ||= qualification_services(Qualification::PROFESSIONAL)
    end

    def qualification_maintenances
      @qualification_maintenances ||= qualification_services(Qualification::MAINTENANCE)
    end

    def trainings
      @trainings ||= training_services
    end

    def literatures
      @literatures ||= model.literatures.map do |literature|
        LiteraturePresenter.new(
          context: context,
          literature: literature,
        )
      end.concat(Literature.joins(:model_literatures).where(model_literatures: { model: "ALL" }).map do |literature|
        LiteraturePresenter.new(
          context: context,
          literature: literature,
        )
      end)
    end

    def qualification_professionals?
      context.audience == User::SERVICE
    end

    def qualification_maintenances?
      context.audience == User::SERVICE
    end

    private

    def contract_condition_services(type)
      model.
        prices.
        joins(:contract_condition).
        where(
          country: context.country,
          contract_conditions: { type: type },
        ).
        where(
          ":audience = any(contract_conditions.audience)",
          audience: context.audience,
        ).
        preload(:contract_condition).
        group_by(&:cleansku).
        map do |cleansku, prices|
          Services::ContractConditionPresenter.new(
            context: context,
            contract_condition: prices.first.contract_condition,
            prices: prices.map { |price| PricePresenter.new(context: context, price: price) },
          )
        end
    end

    def training_services
      model.
        training_prices.
        where(
          prices: { country: context.country },
        ).
        where(
          ":audience = any(trainings.audience)",
          audience: context.audience,
        ).
        preload(:training).
        group_by(&:cleansku).
        map do |cleansku, prices|
          Services::TrainingPresenter.new(
            context: context,
            training: prices.first.training,
            prices: prices.map { |price| PricePresenter.new(context: context, price: price) },
          )
        end
    end

    def qualification_services(category)
      model.
        qualification_prices.
        where(
          prices: { country: context.country },
          qualifications: { category: category },
        ).
        where(
          ":audience = any(qualifications.audience)",
          audience: context.audience,
        ).
        preload(:qualification).
        group_by(&:cleansku).
        map do |cleansku, prices|
          Services::QualificationPresenter.new(
            context: context,
            qualification: prices.first.qualification,
            prices: prices.map { |price| PricePresenter.new(context: context, price: price) },
          )
        end
    end
  end
end
