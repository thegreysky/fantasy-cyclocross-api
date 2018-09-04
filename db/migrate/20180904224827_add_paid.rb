class AddPaid < ActiveRecord::Migration[5.2]
  def change
    add_column :teams, :paid, :boolean, :default => false
  end
end
