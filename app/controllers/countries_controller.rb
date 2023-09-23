class CountriesController < ApplicationController

  def index
    countries = ServiceHub::SupportedCountries.list
    render json: countries
  end
end
