class MatchupsController < ApplicationController
  include ActionController::MimeResponds

  # GET /matchups
  def index
    @matchups = Matchup.all

    render json: @matchups
  end

end
