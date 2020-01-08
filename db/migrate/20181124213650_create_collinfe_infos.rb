class CreateCollinfeInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :collinfe_infos do |t|
 	  t.integer :card_id
      t.longtext :content
      t.integer :collinfe_id
      t.timestamps
    end
  end
end
