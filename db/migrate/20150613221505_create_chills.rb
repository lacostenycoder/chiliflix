class CreateChills < ActiveRecord::Migration
  def change
    create_table :chills do |t|
      t.text :description
      t.timestamps null: false
    end
  end
end
