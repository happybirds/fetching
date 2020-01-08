class CreateOlfInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :olf_infos do |t|
      t.integer :olf_id
      t.string :name
      t.string :href
      t.longtext :content
      t.timestamps
    end
  end
end
