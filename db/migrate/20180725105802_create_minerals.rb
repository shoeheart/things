class CreateMinerals < ActiveRecord::Migration[5.2]
  def change
    create_table :minerals do |t|
      t.string :name
      t.boolean :igneous

      t.timestamps
    end
  end
end
