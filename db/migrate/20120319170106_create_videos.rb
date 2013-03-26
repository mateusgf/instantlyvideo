class CreateVideos < ActiveRecord::Migration
  def change
    create_table :videos do |t|
      t.datetime :date
      t.string :coordinates
      t.string :address
      t.string :video
      t.string :title
      t.integer :user_id

      t.timestamps
    end
  end
end
