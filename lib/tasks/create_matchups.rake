def find_team_not_playing(teams, matchups)
  teams.reject { |t| team_is_playing(t, matchups) }.first
end

def team_is_playing(team, matchups)
  matchups.any? { |h| team.name == h[:home] || team.name == h[:away] }
end

def get_not_matched_yet(team, teams, weeks)
  all_match_ups = weeks.inject([]){|a,e| a.concat(e[1]) }

  teams.reject { |t|
    all_match_ups.any? {|m|
      m[:home] == team.name && m[:away] == t.name ||
          m[:home] == t.name && m[:away] == team.name
    } || t.name == team.name
  }
end

task :create_matchups => :environment do

  teams = Team.all.collect { |x| x.name }
  match_ups = {}
  number_of_weeks = teams.count
  match_ups_per_week = (teams.count / 2).ceil

  starting_way = teams.each_slice(match_ups_per_week).to_a
  starting_way_base = starting_way.clone

  reverse_way = starting_way.clone.reverse
  reverse_way_base = reverse_way.clone

  for week in 2..(number_of_weeks / 2) do
    new_array = starting_way_base
    starting_way.concat(new_array)

    new_array = reverse_way_base
    reverse_way.concat(new_array)
  end


  p starting_way.count
  p reverse_way.count

  #
  #
  # for week in 40..(40 + number_of_weeks) do
  #   match_ups[week] = match_ups[week] ? match_ups[week] : []
  #
  #
  # end
  #
  # teams.each_with_index do |team, i|
  #   match_ups[week] = match_ups[week] ? match_ups[week] : []
  # end
  #
  #
  #
  #
  # # 40 - 2
  # teams = Team.all
  # start_week = 40
  # number_of_weeks = teams.count - 1
  # match_ups = {}
  #
  # teams.each_with_index do |team|
  #   p team.name
  #   potential_opponents = get_not_matched_yet(team, teams, match_ups)
  #   for week in 40..(40 + number_of_weeks) do
  #     match_ups[week] = match_ups[week] ? match_ups[week] : []
  #     opponent_not_playing = find_team_not_playing(potential_opponents, match_ups[week])
  #
  #     unless team_is_playing(team, match_ups[week]) || opponent_not_playing == nil
  #
  #       match_ups[week] << {
  #           home: team.name,
  #           away: opponent_not_playing.name
  #       }
  #
  #       potential_opponents.delete(opponent_not_playing)
  #     end
  #   end
  # end
  #
  # puts JSON.pretty_generate(match_ups)


end