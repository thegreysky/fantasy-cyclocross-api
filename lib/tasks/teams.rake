task :add_team, [:name, :owner, :r1, :r2, :r3, :r4, :r5] => :environment do |task, args|
  salary_cap = salary_cap([args[:r1], args[:r2], args[:r3], args[:r4], args[:r5]])
  team_breaking_salary_cap = salary_cap > 50
  team_breaking_rule_of_3 = is_team_breaking_rule_of_3(args)

  if team_breaking_rule_of_3
    p "#{args[:owner]} is being a dick and has more than 3 identical racers as another team"
    next
  end

  if team_breaking_salary_cap
    p "#{args[:owner]} is being a dick and is over $50, they have $#{salary_cap}"
    next
  end

  team = Team.new({:name => args[:name], :owner => args[:owner], :season_id => 26})
  team.save!

  team_id = team.id
  TeamRacer.new({:team_id => team_id, :uci_racer_id => args[:r1], :season_id => 26, :active => true }).save!
  TeamRacer.new({:team_id => team_id, :uci_racer_id => args[:r2], :season_id => 26, :active => true }).save!
  TeamRacer.new({:team_id => team_id, :uci_racer_id => args[:r3], :season_id => 26, :active => true }).save!
  TeamRacer.new({:team_id => team_id, :uci_racer_id => args[:r4], :season_id => 26, :active => true }).save!
  TeamRacer.new({:team_id => team_id, :uci_racer_id => args[:r5], :season_id => 26, :active => true }).save!
end

task :change_racer, [:team_id, :r1, :r2] => :environment do |task, args|
  team_id = args[:team_id]
  teams_racers = TeamRacer.where(team_id: args[:team_id]).map(&:uci_racer_id)
  teams_racers.delete(args[:r1].to_i)
  teams_racers.push(args[:r2].to_i)
  salary_cap = salary_cap(teams_racers)
  team_breaking_salary_cap = salary_cap > 50

  if team_breaking_salary_cap
    p "Change makes the team over $50, they have $#{salary_cap}"
    next
  end

  previous_racer = TeamRacer.where(team_id: team_id, uci_racer_id: args[:r1])[0]
  previous_racer.active = false
  previous_racer.save

  TeamRacer.new({:team_id => team_id, :uci_racer_id => args[:r2], :season_id => 26, :active => true }).save!
end

def salary_cap(racers)
  UciRacer.where("id in (#{racers[0]}, #{racers[1]}, #{racers[2]}, #{racers[3]}, #{racers[4]})").map(&:cost).inject(0, &:+).to_f
end

def is_team_breaking_rule_of_3(args)
  ActiveRecord::Base.connection.execute("
                          SELECT
                            count(*)
                          FROM
                            team_racers
                          WHERE
                            uci_racer_id in (#{args[:r1]}, #{args[:r2]}, #{args[:r3]}, #{args[:r4]}, #{args[:r5]})
                          GROUP BY
                            team_id
                            ").values.flatten().any? {|c| c > 3}
end
