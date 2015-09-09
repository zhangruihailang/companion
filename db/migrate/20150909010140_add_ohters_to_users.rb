class AddOhtersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :rolename, :string
    add_column :users, :guardian_age, :integer
    add_column :users, :province, :string
    add_column :users, :city, :string
    add_column :users, :district, :string
    add_column :users, :sex, :string
    add_column :users, :age, :integer
    add_column :users, :school, :string
    add_column :users, :interests, :string
  end
end
