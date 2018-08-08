class AddCountryToRacer < ActiveRecord::Migration[5.2]
  def change
    add_column :uci_racers, :country, :string
  end
end
