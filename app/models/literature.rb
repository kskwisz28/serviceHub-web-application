class Literature < ApplicationRecord
  KINDS = [
    INSTRUMENT = "Instrument Services".freeze,
    QUALIFICATION = "Qualification Services".freeze,
    CONSULTING = "Consulting Services".freeze,
    EDUCATION = "Education Services".freeze,
    PROMOTION = "Promotion".freeze,
	RESTART = "System Restart".freeze,
  ].freeze

  has_many :model_literatures, primary_key: :asset_url, foreign_key: :asset_url
end
