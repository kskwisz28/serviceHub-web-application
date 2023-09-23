class ModelLiterature < ApplicationRecord
  belongs_to :model, primary_key: :model_id, foreign_key: :model_id
  belongs_to :literature, primary_key: :asset_url, foreign_key: :asset_url
end
