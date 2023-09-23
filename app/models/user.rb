class User < ApplicationRecord
  ROLES = [
    INSTRUMENT = "InstrumentSales".freeze,
    SERVICE = "ServiceSales".freeze,
	SUPPORT = "ServiceAndSupport".freeze,
  ].freeze

  ADMINS = [
    { name: "Scott Mueller", email: "scott.mueller@thermofisher.com" },
    { name: "Jeremy Schuurmans", email: "jeremy@redsquirrel.com" },
    { name: "Blaise Yen", email: "blaise.yen@thermofisher.com" },
    { name: "Sales Person", email: "sales.person@thermofisher.com" }
  ].freeze

  has_many :email_messages

  before_validation :default_role
  before_validation :default_country

  validates :role, inclusion: { in: ROLES }

  def country_name=(value)
    self.country_code = countries.find { |c| c[:name] == value }[:code]
  end

  def country_name
    if (country_code)
      countries.find { |c| c[:code] == self.country_code }[:name]
    end
  end

  def countries
    @countries ||= ServiceHub::SupportedCountries.list
  end

  def is_admin?
    ADMINS.find{|admin| admin[:email] == email }
  end

  private

  def default_role
    self.role ||= INSTRUMENT
  end

  def default_country
    self.country_code ||= "US"
  end
end
