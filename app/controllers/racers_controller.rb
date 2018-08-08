class RacersController < ApplicationController
  include ActionController::MimeResponds

  # GET /racers
  def index
    @racers = UciRacer.order("cost DESC")

    render json: @racers
  end
end
