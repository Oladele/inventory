# == Schema Information
#
# Table name: categories
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  description :string(255)
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Category < ActiveRecord::Base
  attr_accessible :description, :name
  belongs_to :user
  has_many :items

  validates :name, presence: true, length: { maximum: 20 }
  validates :user_id, presence: true

  default_scope order: 'categories.name ASC'

  before_destroy :check_dependent_records

  def can_destroy?
    FALSE unless self.items.count == 0
  end

  private

  def check_dependent_records
  	raise "Dependent records exist: #{self.items.to_s}" unless self.can_destroy?
  end


end
