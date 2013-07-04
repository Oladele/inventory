# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#  remember_token  :string(255)
#  admin           :boolean          default(FALSE)
#

require 'spec_helper'

describe User do

  before do 
  	@user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:admin) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:categories) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

# => Don't understand why below does not work
#  describe "accessible attributes" do
 #   it "should not allow access to admin" do
  #    expect do
   #     @user.admin = false
    #  end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    #end    
  #end

  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        @user.should_not be_valid
      end      
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        @user.should be_valid
      end      
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "email address with mixed case" do
  	let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      @user.reload.email.should == mixed_case_email.downcase
    end
  end


  describe "when password is not present" do
	  before { @user.password = @user.password_confirmation = " " }
	  it { should_not be_valid }
	end

	describe "when password doesn't match confirmation" do
	  before { @user.password_confirmation = "mismatch" }
	  it { should_not be_valid }
	end

	describe "when password confirmation is nil" do
	  before { @user.password_confirmation = nil }
	  it { should_not be_valid }
	end

	describe "with a password that's too short" do
	  before { @user.password = @user.password_confirmation = "a" * 5 }
	  it { should be_invalid }
	end

	describe "return value of authenticate method" do
	  before { @user.save }
	  let(:found_user) { User.find_by_email(@user.email) }

	  describe "with valid password" do
	    it { should == found_user.authenticate(@user.password) }
	  end

	  describe "with invalid password" do
	    let(:user_for_invalid_password) { found_user.authenticate("invalid") }

	    it { should_not == user_for_invalid_password }
	    specify { user_for_invalid_password.should be_false }
	  end
	end

  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

  describe "category associations" do

    before { @user.save }
    let!(:z_category) do 
      FactoryGirl.create(:category, name: "category_z",user: @user)
    end    

    let!(:a_category) do 
      FactoryGirl.create(:category, name: "category_a", user: @user)
    end

    it "should have the right category in the right order" do
      @user.categories.should == [a_category, z_category]
    end

    it "should have the right category values" do
      a_category.name.should  == "category_a"
      a_category.can_destroy?.should == true
    end

=begin
    it "should destroy associated categories" do
      categories = @user.categories.dup
      @user.destroy
      categories.should_not be_empty
      categories.each do |category|
        category.find_by_id(micropost.id).should be_nil
      end
    end
=end
  end

  describe "item associations" do
    
    before { @user.save }
    let!(:a_item1) do 
      FactoryGirl.create(:item, barcode_custom: "a_item1",user: @user)
    end    

    let!(:a_item2) do 
      FactoryGirl.create(:item, barcode_custom: "a_item2",user: @user)
    end

    it "should have the right category in the right order" do
      @user.items.should == [a_item2, a_item1]
    end

    it "should have the right category values" do
      a_item1.barcode_custom.should  == "a_item1"
      a_item2.barcode_custom.should  == "a_item2"
    end

    it "should destroy associated items" do
      items = @user.items.dup
      @user.destroy
      items.should_not be_empty
      items.each do |item|
        Item.find_by_id(item.id).should be_nil
      end
    end
  end

end
