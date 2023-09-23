class Package < ApplicationRecord
  belongs_to :model, primary_key: :model_id, foreign_key: :model_id

  has_many :packages, primary_key: :pkg_sku, foreign_key: :pkg_sku
  has_many :prices, primary_key: :pkg_sku, foreign_key: :cleansku
  has_many :component_prices, primary_key: :component_sku, foreign_key: :cleansku, class_name: "Price"
  has_many :qualifications, primary_key: :pkg_sku, foreign_key: :sku_nbr
  has_many :trainings, primary_key: :pkg_sku, foreign_key: :sku_nbr

  has_many :contract_conditions, through: :component_prices

  scope :root, -> { where(component_type: "Package") }
  scope :children, -> { where.not(component_type: "Package") }
end
