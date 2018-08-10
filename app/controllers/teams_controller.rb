class TeamsController < ApplicationController
  include ActionController::MimeResponds

  # GET /teams
  def index
    @teams = Team.all

    render json: @teams
  end
end
