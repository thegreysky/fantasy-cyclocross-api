class AddCountryShortToRacer < ActiveRecord::Migration[5.2]
  def change
    add_column :uci_racers, :country_short, :string
  end
end
