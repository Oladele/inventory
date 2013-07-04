# == Schema Information
#
# Table name: items
#
#  id             :integer          not null, primary key
#  barcode_custom :string(255)
#  category_id    :integer
#  scan_datetime  :datetime
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class Item < ActiveRecord::Base
  attr_accessible :barcode_custom, :scan_datetime
  belongs_to :category

  validates :category_id, presence: true
  validates :barcode_custom, presence: true, length: { maximum: 40 }

  default_scope order: 'items.barcode_custom DESC'
end
