task :get_racers => :environment do
  UciRacer.where("name like '%vos%'").each do |racer|
    p "#{racer.name} #{racer.previous_year_points} #{racer.cost}"
  end
  UciRacer.order("previous_year_points DESC").last(20).each do |racer|
    p "#{racer.name} #{racer.previous_year_points} #{racer.cost}"
  end
end

task :racers => :environment do
  save_category_racers(163, 'Men Elite')
  save_category_racers(168, 'Women Elite')
end

task :set_cost => :environment do
  UciRacer.order("previous_year_points DESC").each_with_index do |racer, i|
    middle = racer.previous_year_points * (0.00017 - (i * 0.00000019))
    racer.cost = (racer.previous_year_points * 0.008503072407045) * ((1 + 1/middle)**middle)
    racer.save
  end
end

def save_category_racers(category_id, category_name)
  get_racers(category_id).each do |racer|
    UciRacer.new({
                     :uci_generated_racer_id => "#{racer['FullName']}#{racer['BirthDate']}25",
                     :season_id => "25",
                     :uci_id => racer['UciId'],
                     :name => racer['FullName'],
                     :previous_year_points => racer['Points'],
                     :category => category_name,
                 }).save rescue nil
  end
end

def get_racers (category_id)
  HTTParty.post("https://dataride.uci.ch/Results/iframe/ObjectRankings/",
                :body => {
                    :rankingId => category_id,
                    :disciplineId => 3,
                    :rankingTypeId => 1,
                    :take => 297,
                    :skip => 0,
                    :page => 1,
                    :pageSize => 297,
                    'filter[filters][0][field]' => 'RaceTypeId',
                    'filter[filters][0][value]' => '0',
                    'filter[filters][1][field]' => 'CategoryId',
                    'filter[filters][1][value]' => '22',
                    'filter[filters][2][field]' => 'SeasonId',
                    'filter[filters][2][value]' => '25',
                    'filter[filters][3][field]' => 'MomentId',
                    'filter[filters][3][value]' => '',
                    'filter[filters][4][field]' => 'CountryId',
                    'filter[filters][4][value]' => '0',
                    'filter[filters][5][field]' => 'IndividualName',
                    'filter[filters][5][value]' => '',
                    'filter[filters][6][field]' => 'TeamName',
                    'filter[filters][6][value]' => '',
                }).parsed_response['data']
end