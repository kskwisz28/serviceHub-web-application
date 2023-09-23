class Training < ApplicationRecord
  has_many :prices, primary_key: :sku_nbr, foreign_key: :cleansku
end
