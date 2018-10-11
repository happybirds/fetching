class CreateCardInfos < ActiveRecord::Migration[5.2]
  def change
    create_table :card_infos do |t|
      t.integer :card_id
      t.longtext :content
      t.timestamps
    end
  end
end
