class AlertBar < ApplicationRecord
  validates :description, presence: true

  def self.active
    where(active: true).first
  end

  def archive!
    update(active: false)
  end
end
