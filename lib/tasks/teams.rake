task :add_team, [:name, :owner, :r1, :r2, :r3, :r4, :r5] => :environment do |task, args|
  salary_cap = salary_cap(args)
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

def salary_cap(args)
  UciRacer.where("id in (#{args[:r1]}, #{args[:r2]}, #{args[:r3]}, #{args[:r4]}, #{args[:r5]})").map(&:cost).inject(0, &:+).to_f
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
