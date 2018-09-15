class CreateCampus < ActiveRecord::Migration[5.2]
  def change
    create_table :campus do |t|
		t.string :image_uri
		t.string :title
		t.string :title_uri
		t.string :send_time
		t.longtext :content
		t.integer :status
      t.timestamps
    end
  end
end
