class CreateTeams < ActiveRecord::Migration[5.2]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :owner
      t.integer :season_id

      t.timestamps
    end
  end
end
