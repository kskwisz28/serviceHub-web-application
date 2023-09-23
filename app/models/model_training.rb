class ModelTraining < ApplicationRecord
  belongs_to :model, primary_key: :model_id, foreign_key: :model_id
  belongs_to :training, primary_key: :sku_nbr, foreign_key: :sku_nbr
end
