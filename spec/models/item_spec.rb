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

require 'spec_helper'

describe Item do
	let(:user) { FactoryGirl.create(:user) }
  before do
  	@category = user.categories.create(name: "book", description: "readable")
  	@item = @category.items.create(barcode_custom: "book123")
  end

  subject { @item }

  it { should respond_to(:barcode_custom) }
  it { should respond_to(:category_id) }
  it { should respond_to(:scan_datetime) }

  it { should respond_to(:category) }
	its(:category) { should == @category }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Item.new(category_id: @category.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when category_id is not present" do
    before { @item.category_id = nil }
    it { should_not be_valid }
  end

  describe "with blank barcode_custom" do
    before { @item.barcode_custom = " " }
    it { should_not be_valid }
  end

  describe "with content that is too long" do
    before { @item.barcode_custom = "a" * 41 }
    it { should_not be_valid }
  end
end
