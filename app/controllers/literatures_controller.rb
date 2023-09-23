class LiteraturesController < ApplicationController
  attr_reader :instrument_presenter

  helper_method :presenter
  helper_method :instrument_presenter

  def show

    if params[:literature]
      @instrument = find_instrument(literature_params)
      @instrument_presenter = Presenters::ModelPresenter.new(model: @instrument, context: application_context)
    end
  end

  private

  def find_instrument(query)
    search = query[:search]
    Model.find_by(model_id: search) || Model.where("model_id || ' - ' || public_description = :model", model: search).first
  end

  def literature_params
    params.require(:literature).permit(:search)
  end

  def presenter
    @presenter ||= Presenters::LiteraturesPresenter.new(context: application_context)
  end
end
