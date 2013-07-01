class CreateItems < ActiveRecord::Migration
  def change
    create_table :items do |t|
      t.string :barcode_custom
      t.integer :category_id
      t.datetime :scan_datetime

      t.timestamps
    end
  end
end
