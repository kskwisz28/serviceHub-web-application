class ContractCondition < ApplicationRecord
  TYPES = [
    ADDON = "Contract Add-on".freeze,
    STANDALONE = "Contract".freeze,
  ]

  belongs_to :price, primary_key: :pricing_condition, foreign_key: :pricing_condition
end
