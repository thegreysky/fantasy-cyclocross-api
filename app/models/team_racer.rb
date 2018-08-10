class TeamRacer < ApplicationRecord
  belongs_to :team
  belongs_to :uci_racer
end
