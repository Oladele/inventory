class RemoveIndexBarcodeCustomInItems < ActiveRecord::Migration
  def up
  	remove_index :items, :barcode_custom
  end

  def down
  	add_index :items, :barcode_custom, unique: true
  end
end
