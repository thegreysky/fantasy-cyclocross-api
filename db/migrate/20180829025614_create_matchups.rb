class CreateMatchups < ActiveRecord::Migration[5.2]
  def change
    create_table :matchups do |t|
      t.integer :home_team_id
      t.integer :away_team_id
      t.integer :week_number
      t.integer :year
      t.integer :season_id

      t.timestamps
    end
  end
end
