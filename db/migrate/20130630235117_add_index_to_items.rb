class AddIndexToItems < ActiveRecord::Migration
  def change
    add_index :items, :barcode_custom, unique: true
  end
end
