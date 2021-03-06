class Team < ApplicationRecord
  has_many :team_racers
  has_many :uci_racers, :through => :team_racers

  def points
    team_racers.map(&:team_racer_results).inject([], &:concat).map(&:points).inject(0, &:+)
  end

  def racers
    uci_racers.each do |racer|
      team_racer = team_racers.select { |tr| tr.uci_racer_id == racer.id }[0]
      racer.active = team_racer.active
      racer.results = team_racer.team_racer_results
    end
    uci_racers
  end
end
