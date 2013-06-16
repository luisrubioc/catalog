require 'spec_helper'

describe Directory do
  let(:user) { FactoryGirl.create(:user) }
  before { @directory = user.directories.build(name: "Example Directory", description: "Description text for example directory") }

  subject { @directory }

  it { should respond_to(:user_id) }
  it { should respond_to(:name) }
  it { should respond_to(:description) }

  it { should be_valid }
  
  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
        Directory.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end    
  end

  describe "when user_id is not present" do
    before { @directory.user_id = nil }
    it { should_not be_valid }
  end

  describe "with blank name" do
    before { @directory.name = " " }
    it { should_not be_valid }
  end

  describe "with a name that is too long" do
    before { @directory.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "with a description that is too long" do
    before { @directory.description = "a" * 501 }
    it { should_not be_valid }
  end
end
