task :get_results => :environment do
  competitions = get_last_two_weeks_of_competitions

  competitions.each{ |c|
    get_races(c["CompetitionId"]).each{|r|
      get_results(r["Id"]).each{|result|
        racer = UciRacer.where("uci_generated_racer_id = '#{result['DisplayName']}#{result['BirthDate']}25'").first

        if racer != nil
          UciResult.new({
                            :racer_id => racer.id,
                            :race_id => r["Id"],
                            :competition_name => c["CompetitionName"],
                            :competition_id => c["CompetitionId"],
                            :category => r["CategoryCode"],
                            :place => result["Rank"],
                            :points => result["PointPcR"],
                        }).save rescue nil
        end
      }
    }
  }

  # CLEAN UP THESE IN PROD
  #
  # 40	BOSMANS Wietse (ERC)/Date(694047600000)/25	25	10006119367	BOSMANS Wietse (ERC)	473	4.9	Men Elite	2018-08-08 04:05:57.094411	2018-08-08 04:06:08.912178	BELGIUM	BE
  # 55	PETROV Spencer (ASR)/Date(905292000000)/25	25	10009771217	PETROV Spencer (ASR)	329	3.25	Men Elite	2018-08-08 04:05:57.139727	2018-08-08 04:06:09.022313	UNITED STATES OF AMERICA	US
  # 58	VAN TICHELT Yorben (ERC)/Date(773964000000)/25	25	10007573458	VAN TICHELT Yorben (ERC)	320	3.15	Men Elite	2018-08-08 04:05:57.14865	2018-08-08 04:06:09.044423	BELGIUM	BE
  # 68	DUBAU Joshua (TPB)/Date(833839200000)/25	25	10008749582	DUBAU Joshua (TPB)	276	2.68	Men Elite	2018-08-08 04:05:57.17913	2018-08-08 04:06:09.108538	FRANCE	FR
  # 91	DUBAU Lucas (TPB)/Date(833839200000)/25	25	10008815563	DUBAU Lucas (TPB)	173	1.61	Men Elite	2018-08-08 04:05:57.248	2018-08-08 04:06:09.44865	FRANCE	FR
  # 133	KIELICH Timo (ERC)/Date(933804000000)/25	25	10010956536	KIELICH Timo (ERC)	101	0.91	Men Elite	2018-08-08 04:05:57.373357	2018-08-08 04:06:09.96295	BELGIUM	BE
  # 313	WORST Annemarie (ERC)/Date(819327600000)/25	25	10008082912	WORST Annemarie (ERC)	880	10.09	Women Elite	2018-08-08 04:05:59.534795	2018-08-08 04:06:08.620311	NETHERLANDS	NL
  # 315	NOBLE Ellen (ASR)/Date(817945200000)/25	25	10009005725	NOBLE Ellen (ASR)	822	9.31	Women Elite	2018-08-08 04:05:59.540412	2018-08-08 04:06:08.714853	UNITED STATES OF AMERICA	US
  # 405	STUMPF Fanny (TPB)/Date(775692000000)/25	25	10009364524	STUMPF Fanny (TPB)	119	1.08	Women Elite	2018-08-08 04:05:59.79589	2018-08-08 04:06:09.817272	FRANCE	FR
  # 4	SWEECK Laurens (ERC)/Date(756082800000)/25	25	10006912646	SWEECK Laurens (ERC)	1743	22.92	Men Elite	2018-08-08 04:05:56.947284	2018-08-08 04:06:08.332621	BELGIUM	BE
  # 44	POWERS Jeremy (ASR)/Date(425685600000)/25	25	10002947467	POWERS Jeremy (ASR)	413	4.2	Men Elite	2018-08-08 04:05:57.106264	2018-08-08 04:06:08.948235	UNITED STATES OF AMERICA	US

end

def get_date(competition)
  split = competition["Date"].split('-')
  last_date = split[split.count - 1]
  Date.strptime(last_date, '%d %b %Y')
end

def get_results(race_id)
  HTTParty.post("https://dataride.uci.ch/Results/iframe/Results/",
                :body => {
                    :disciplineId => 3,
                    :eventId => race_id,
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