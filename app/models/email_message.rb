class EmailMessage < ApplicationRecord
  belongs_to :user

  validate :custom_email_valid

  EMAIL_REGEX_PATTERN = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  def literature
    Literature.where(asset_url: literature_asset_urls)
  end

  def custom_email_valid
    return true unless status == 'complete'

    if !customer_email.present?
      errors.add(:customer_email, "Please add the customer email")
    elsif !(customer_email =~ EMAIL_REGEX_PATTERN)
      errors.add(:customer_email, "Please enter a valid email address.")
    end
  end
end
