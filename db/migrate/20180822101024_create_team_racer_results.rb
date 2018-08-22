class CreateTeamRacerResults < ActiveRecord::Migration[5.2]
  def change
    create_table :team_racer_results do |t|
      t.integer :team_racer_id
      t.integer :uci_result_id
      t.integer :week_number
      t.integer :team_id
      t.integer :points

      t.timestamps
    end

    add_index :team_racer_results, [:team_racer_id, :uci_result_id], unique: true
  end
end
