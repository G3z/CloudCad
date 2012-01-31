class CreateActions < ActiveRecord::Migration
  def change
    create_table :actions do |t|
      t.string :name
      t.integer :project_id
      t.text :data
      t.timestamp :time

      t.timestamps
    end
  end
end
