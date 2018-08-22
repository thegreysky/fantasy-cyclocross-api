task :get_results => :environment do
  competitions = get_last_two_weeks_of_competitions

  competitions.each{ |c|
    get_races(c["CompetitionId"]).each{|r|
      event_id = get_event_id(r["Id"])
      get_results(event_id).each{|result|
        racer = UciRacer.where("uci_generated_racer_id = '#{result['DisplayName'].gsub("'", "")}#{result['BirthDate']}25'").first

        if racer != nil
          current_result = UciResult.new({
                            :racer_id => racer.id,
                            :race_id => r["Id"],
                            :competition_name => c["CompetitionName"],
                            :competition_id => c["CompetitionId"],
                            :category => r["CategoryCode"],
                            :place => result["Rank"],
                            :points => result["PointPcR"],
                        })
          current_result.save

          TeamRacer.where(uci_racer_id: racer.id, active: true).each{|team_racer|
            TeamRacerResult.new({
                                    :team_racer_id => team_racer.id,
                                    :uci_result_id => current_result.id,
                                    :week_number => Time.now.strftime("%U").to_i,
                                    :team_id => team_racer.team_id,
                                    :points => result["PointPcR"],
                                }).save
          }
        end


      }
    }
  }
end

def get_date(competition)
  split = competition["Date"].split('-')
  last_date = split[split.count - 1]
  Date.strptime(last_date, '%d %b %Y')
end

def get_event_id(race_id)
  HTTParty.post("https://dataride.uci.ch/Results/iframe/Events/",
                :body => {
                    :disciplineId => 3,
                    :raceId => race_id
                }).parsed_response.first["EventId"]
end

def get_results(event_id)
  HTTParty.post("https://dataride.uci.ch/Results/iframe/Results/",
                :body => {
                    :disciplineId => 3,
                    :eventId => event_id,
                    :take => 500,
                    :skip => 0,
                    :page => 1,
                    :pageSize => 500
                }).parsed_response['data']
end

def get_races(competition_id)
  HTTParty.post("https://dataride.uci.ch/Results/iframe/Races/",
                :body => {
                    :disciplineId => 3,
                    :competitionId => competition_id,
                    :take => 500,
                    :skip => 0,
                    :page => 1,
                    :pageSize => 500
                }).parsed_response['data']
end

def get_last_two_weeks_of_competitions
  HTTParty.post("https://dataride.uci.ch/Results/iframe/Competitions/",
                :body => {
                    :disciplineId => 3,
                    :take => 500,
                    :skip => 0,
                    :page => 1,
                    :pageSize => 500,
                    'sort[0][field]' => 'StartDate',
                    'sort[0][dir]' => 'desc',
                    'filter[filters][0][field]' => 'RaceTypeId',
                    'filter[filters][0][value]' => '0',
                    'filter[filters][1][field]' => 'CategoryId',
                    'filter[filters][1][value]' => '0',
                    'filter[filters][2][field]' => 'SeasonId',
                    'filter[filters][2][value]' => '126'
                }).parsed_response['data']
      .select{ |c| get_date(c) > (Time.now - 2.weeks) }
end