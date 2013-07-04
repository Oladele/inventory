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

require 'spec_helper'

describe Category do
  let(:user) { FactoryGirl.create(:user) }
  before do
    @category = user.categories.build(name: "Lorem ipsum", description: "Carpe Diem et semper fi")
  end

  subject { @category }

  it { should respond_to(:name) }
  it { should respond_to(:description) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
	its(:user) { should == user }

	it { should respond_to(:items) }

  it { should be_valid }

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Category.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @category.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @category.name = " " }
    it { should_not be_valid }
  end

  describe "with name that is too long" do
    before { @category.name = "a" * 21 }
    it { should_not be_valid }
  end

  describe "category associations" do

    before { @category.save }
    let!(:item1) do 
      FactoryGirl.create(:item, barcode_custom: "barcode1", category: @category)
    end

    let!(:item2) do 
      FactoryGirl.create(:item, barcode_custom: "barcode2", category: @category)
    end

    it "should return have the right items in the right order" do
	      @category.items.should == [item2, item1]
	  end

	  it "should return FALSE for category.can_destroy" do
	      @category.can_destroy?.should == FALSE
	  end

	  it "should raise error when deleting Category with Items" do
	  	lambda do
	      @category.destroy
	    end.should raise_error(RuntimeError)
	  end
	end

end
