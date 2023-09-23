class LeadPass < ApplicationRecord
  REGIONS = [
    "NA",
    "EMEA",
  ].freeze

  belongs_to :user

  validates :region, inclusion: { in: REGIONS }
end
