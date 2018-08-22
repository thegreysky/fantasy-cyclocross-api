class TeamRacer < ApplicationRecord
  belongs_to :team
  belongs_to :uci_racer
  has_many :team_racer_results
end
