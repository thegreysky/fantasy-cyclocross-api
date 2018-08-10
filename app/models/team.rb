class Team < ApplicationRecord
  has_many :team_racers
  has_many :uci_racers, :through => :team_racers
end
