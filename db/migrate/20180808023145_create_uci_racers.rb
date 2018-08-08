class CreateUciRacers < ActiveRecord::Migration[5.2]
  def change
    create_table :uci_racers do |t|
      t.string :uci_generated_racer_id
      t.string :season_id
      t.integer :uci_id
      t.string :name
      t.integer :previous_year_points
      t.decimal :cost, precision: 5, scale: 2
      t.string :category

      t.timestamps
    end

    add_index :uci_racers, :uci_generated_racer_id, unique: true
  end
end
