class TeamsController < ApplicationController
  include ActionController::MimeResponds
  before_action :set_team, only: [:show]


  # GET /teams
  def index
    @teams = Team.all

    render json: @teams
  end

  # GET /teams/1
  def show
    render json: @team, serializer: TeamDetailsSerializer
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_team
    params[:id] ||= params[:team_id]
    @team = Team.find(params[:id])
  end
end
