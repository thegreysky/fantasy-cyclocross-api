

task :do_results => :environment do
  competitions = all_competitions

  competitions.each do |competition|
    p competition["CompetitionName"]
    all_races(competition["CompetitionId"]).each do |race|
      p race["RaceName"]
      details = race_details(race['Id'])
      race_results(details['EventId']).each do |result|
        points = result['PointPcR'] ? result['PointPcR'] : 0
        p "#{points} - #{result['DisplayName']} - #{result['BirthDate']}"
      end
    end
  end
end

def race_details (raceId)
  HTTParty.post("https://dataride.uci.ch/Results/iframe/Events/",
                :body => {
                    :disciplineId => 3,
                    :raceId => raceId
                }).parsed_response[0]
end

def race_results (raceId)
  HTTParty.post("https://dataride.uci.ch/Results/iframe/Results/",
                :body => {
                    :disciplineId => 3,
                    :eventId => raceId,
                    :take => 40,
                    :skip => 0,
                    :page => 1,
                    :pageSize => 40,
                }).parsed_response['data']
end

def all_races (competitionId)
  HTTParty.post("https://dataride.uci.ch/Results/iframe/Races/",
                :body => {
                    :disciplineId => 3,
                    :competitionId => competitionId,
                    :take => 40,
                    :skip => 0,
                    :page => 1,
                    :pageSize => 40,
                }).parsed_response['data']
end

def all_competitions
  [HTTParty.post("https://dataride.uci.ch/Results/iframe/Competitions/",
                           :body => {
                               'disciplineId' => 3,
                               'take' => 500,
                               'skip' => 0,
                               'page' => 1,
                               'pageSize' => 500,
                               'sort[0][field]' => 'StartDate',
                               'sort[0][dir]' => 'desc',
                               'filter[filters][0][field]' => 'RaceTypeId',
                               'filter[filters][0][value]' => 0,
                               'filter[filters][1][field]' => 'CategoryId',
                               'filter[filters][1][value]' => 0,
                               'filter[filters][2][field]' => 'SeasonId',
                               'filter[filters][2][value]' => 25
                           }).parsed_response['data'][0]]
end