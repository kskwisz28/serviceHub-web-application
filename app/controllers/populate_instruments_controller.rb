require 'service_hub/populate_instruments'

class PopulateInstrumentsController < ApplicationController

  def new
  end

  def create
    Process.fork {
      ServiceHub::PopulateInstruments.new.run
    }
    redirect_to instruments_path, notice: "Instruments now being updated."
  end

end
