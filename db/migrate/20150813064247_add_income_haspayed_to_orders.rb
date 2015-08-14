class AddIncomeHaspayedToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :income, :float
    add_column :orders, :has_payed, :string
  end
end
