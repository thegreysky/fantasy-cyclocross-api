class CreateUciResults < ActiveRecord::Migration[5.2]
  def change
    create_table :uci_results do |t|
      t.integer :racer_id
      t.integer :race_id
      t.string :competition_name
      t.integer :competition_id
      t.string :category
      t.integer :place
      t.integer :points

      t.timestamps
    end

    add_index :uci_results, [:racer_id, :race_id], unique: true
  end
end
