class MakeUciIdString < ActiveRecord::Migration[5.2]
  def change
    change_column :uci_racers, :uci_id, :string
  end
end
