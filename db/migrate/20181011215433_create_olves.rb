class CreateOlves < ActiveRecord::Migration[5.2]
  def change
    create_table :olves do |t|
      t.string :name
      t.string :href
      t.timestamps
    end
  end
end
