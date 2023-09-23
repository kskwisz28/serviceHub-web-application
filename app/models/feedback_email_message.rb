class FeedbackEmailMessage < ApplicationRecord
  EMAIL_REGEX_PATTERN = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :subject_line, presence: true
  validates :body, presence: true
  validates :sender_email, presence: true
  validates :sender_email, format: { with: EMAIL_REGEX_PATTERN }
end
