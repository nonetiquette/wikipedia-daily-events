class CreateWikipediaDates < ActiveRecord::Migration
  def change
    create_table :wikipedia_dates do |t|
      t.string :permalink, index: true
      t.string :page_url
      t.date :occurred_on, index: true
      t.timestamps
    end
  end
end
