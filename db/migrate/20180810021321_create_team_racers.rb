class CreateTeamRacers < ActiveRecord::Migration[5.2]
  def change
    create_table :team_racers do |t|
      t.integer :uci_racer_id
      t.integer :team_id
      t.boolean :active
      t.integer :season_id

      t.timestamps
    end
  end
end
