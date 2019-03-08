class TeamWithResultsUciRacerSerializer < TeamUciRacerSerializer
  attribute :results

  def results
      object.race_results.sort_by{|e| e.id}.map{|r| {
          :competition_name => r.competition_name,
          :category => r.category,
          :place => r.place,
          :points => r.points
      }}
  end
end
  