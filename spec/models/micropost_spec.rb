# == Schema Information
#
# Table name: microposts
#
#  id            :integer          not null, primary key
#  content       :string(255)
#  user_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  reply_at_user :integer
#

require 'spec_helper'

describe Micropost do
  let(:user){FactoryGirl.create(:user)}

  before do
    @micropost = user.microposts.build(content: "Lorem ipsum")
  end
  
  subject{@micropost}

  it{should respond_to(:content)}
  it{should respond_to(:user_id)}
  it{should respond_to(:user)}
  it{should respond_to(:reply_at_user)}
  its(:user) {should == user}

  it{should be_valid}

  describe "when user_id is not present" do
    before{@micropost.user_id = nil}
    it{should_not be_valid}
  end

  describe "accessible attributes" do 
    it "should not allow access to user_id" do
      expect do
        Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "with blank content" do 
    before{@micropost.content = " "} 
    it{should_not be_valid}
  end

  describe "with content that's too long" do
    before{@micropost.content = "a" * 141}
    it{should_not be_valid}
  end

  describe "@replies" do  
    describe "without @user" do
      its(:reply_at_user) {should be_nil}
    end

    describe "with @user" do
      let(:recipient){FactoryGirl.create(:user)}
      before do 
        @micropost.content = "@#{recipient.email} hi"
        @micropost.save
      end
      its(:reply_at_user) {should equal(recipient.id)}
    end
  end
end
