class Price < ApplicationRecord
  SOURCES = [
    SAP = "SAP".freeze,
    E1 = "E1".freeze,
  ].freeze

  belongs_to :package, primary_key: :pkg_sku, foreign_key: :cleansku
  belongs_to :training, primary_key: :sku_nbr, foreign_key: :cleansku
  belongs_to :qualification, primary_key: :sku_nbr, foreign_key: :cleansku
  belongs_to :contract_condition, primary_key: :pricing_condition, foreign_key: :pricing_condition
end
