class Model < ApplicationRecord
  has_many :packages, -> { root }, primary_key: :model_id, foreign_key: :model_id
  has_many :model_trainings, primary_key: :model_id, foreign_key: :model_id
  has_many :model_qualifications, primary_key: :model_id, foreign_key: :model_id
  has_many :model_literatures, primary_key: :model_id, foreign_key: :model_id
  has_many :prices, primary_key: :model_id, foreign_key: :model_official

  has_many :trainings, through: :model_trainings
  has_many :qualifications, through: :model_qualifications
  has_many :literatures, through: :model_literatures

  has_many :training_prices, through: :trainings, class_name: "Price", source: :prices
  has_many :qualification_prices, through: :qualifications, class_name: "Price", source: :prices
  has_many :package_prices, through: :packages, class_name: "Price", source: :prices

  def name
    "#{model_id} - #{public_description}"
  end
  def status
    "#{status}"
  end
end
