class InstrumentskusController < ApplicationController
  attr_reader :presenter

  helper_method :presenter

  def index
    @instruments = Model.select(:model_id, :skus).map do |instrument|
      instrument.skus != nil ? "#{instrument.model_id} - #{instrument.skus}" : ""
    end

    render json: @instruments
  end

  def show
    if params[:instrument]
      @show_full_instrument = true
      query = instrument_params[:searchsku]

      @instrument = find_instrument(query)
      if @instrument
        @presenter = Presenters::Model.new(model: @instrument, context: application_context)
        @str_query = "?model=#{@instrument.model_id}&country=#{current_user.country_code}&role=#{current_user.role}"
        @current_instrument_model = @instrument.model_id
      end
    elsif model_name = params[:model]
      @show_full_instrument = true
      @instrument = find_instrument(model_name)
      if @instrument
        @presenter = Presenters::ModelPresenter.new(model: @instrument, context: application_context)
        @str_query = "?model=#{@instrument.model_id}&country=#{current_user.country_code}&role=#{current_user.role}"
        @current_instrument_model = @instrument.model_id
      end
    end
  end

  private

  def find_instrument(query)
    searchsku = query[:searchsku] rescue query
    Model.find_by(model_id: searchsku) || Model.where("model_id || ' - ' || skus = :model", model: search).first
  end

  def instrument_params
    params.require(:model).permit(:searchsku)
  end
end
