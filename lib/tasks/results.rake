task :get_results => :environment do
  competitions = get_last_two_weeks_of_competitions

  competitions.each{ |c|
    race_class = c["ClassCode"]
    get_races(c["CompetitionId"]).each{|r|
      event_id = get_event_id(r["Id"])
      race_category = r["CategoryCode"]

      get_results(event_id).each{|result|
        racer = UciRacer.where("uci_generated_racer_id = '#{result['DisplayName'].gsub("'", "")}#{result['BirthDate']}25'").first
        points = result["PointPcR"] ? result["PointPcR"] : get_points(race_class, race_category, result["Rank"].to_i)

        if racer != nil
          current_result = UciResult.find_or_initialize_by({:racer_id => racer.id, :race_id => r["Id"]})
          current_result.competition_name = c["CompetitionName"]
          current_result.competition_id = c["CompetitionId"]
          current_result.category = r["CategoryCode"]
          current_result.place = result["Rank"]
          current_result.points = points
          current_result.save rescue nil

          TeamRacer.where(uci_racer_id: racer.id, active: true).each{|team_racer|
            current_team_result = TeamRacerResult.find_or_initialize_by({:team_racer_id => team_racer.id, :uci_result_id => current_result.id})
            current_team_result.week_number = Time.now.strftime("%U").to_i
            current_team_result.team_id = team_racer.team_id
            current_team_result.points = points
            current_team_result.save
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

def get_points(race_class, race_category, place)
  points = {
      "CDM": [0, 200, 160, 140, 120, 110, 100, 90, 80, 70, 60, 58, 56, 54, 52, 50, 48, 46, 44, 42, 40, 39, 38, 37, 36, 35, 34, 33, 32, 31, 30, 29, 28, 27, 26, 25, 24, 23, 22, 21, 20, 19, 18, 17, 16, 15, 14, 13, 12, 11, 10, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5],
      "C1": [0, 80, 60, 40, 30, 25, 20, 17, 15, 12, 10, 8, 6, 4, 2, 1],
      "C2": [0, 40, 30, 20, 15, 10, 8, 6, 4, 2, 1],
      "MU": [0, 30, 20, 15, 12, 10, 8, 6, 4, 2, 1],
      "MJ": [0, 10, 6, 4, 2, 1]
  }

  actual_place = place ? place : 0
  actual_class = race_class
  actual_class = 'MJ' if race_category.include? 'Junior'
  actual_class = 'MU' if race_category.include? 'Under 23'

  place_points = points[actual_class.to_sym][actual_place]

  place_points ? place_points : 0
end
