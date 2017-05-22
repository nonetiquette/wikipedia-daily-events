class CreateWikipediaEvents < ActiveRecord::Migration
  def change
    create_table :wikipedia_events do |t|
      t.belongs_to :wikipedia_date, index: true
      t.string :permalink, index: true
      t.string :page_url
      t.string :title
      t.text :summary
      t.string :image_url
      t.datetime :last_edited_at
      t.timestamps
    end
  end
end
