class Qualification < ApplicationRecord
  CATEGORIES = [
    QUALIFICATION = "Qualification Services".freeze,
    PROFESSIONAL = "Professional Services".freeze,
    MAINTENANCE = "Planned Maintenance".freeze,
  ].freeze

  has_many :prices, primary_key: :sku_nbr, foreign_key: :cleansku
end
