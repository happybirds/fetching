class CreateCollinves < ActiveRecord::Migration[5.2]
  def change
    create_table :collinves do |t|
   	  t.string :name
      t.string :href
      t.timestamps
    end
  end
end
