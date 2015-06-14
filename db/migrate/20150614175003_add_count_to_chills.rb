class AddCountToChills < ActiveRecord::Migration
  def change
    add_column :chills, :fridge_count, :integer
    add_column :chills, :chills_count, :integer
  end
end
