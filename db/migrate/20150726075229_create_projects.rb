class CreateProjects < ActiveRecord::Migration
  def change
    create_table :projects do |t|
      t.string :name
      t.float :yield_yearly
      t.integer :investment_cycle
      t.string :risk_rank
      t.decimal :borrowing_total
      t.integer :min_investment_amount
      t.date :latest_payment_date
      t.date :latest_expire_date
      t.string :repay_type
      t.text :introduction
      t.text :assets_explain
      t.text :risk_control_measures
      t.text :guarantee_status
      t.text :money_flow
      #t.json :credentials

      t.timestamps null: false
    end
  end
end
