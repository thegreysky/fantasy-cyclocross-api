class Team < ApplicationRecord
  has_many :team_racers
  has_many :uci_racers, :through => :team_racers

  def racers
    uci_racers.each do |racer|
      p uci_racers
      team_racer = team_racers.select { |tr| tr.uci_racer_id == racer.id }[0]
      racer.active = team_racer.active
    end
    uci_racers
  end
end
