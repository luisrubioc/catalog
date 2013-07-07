require 'spec_helper'

describe "Directories pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "directory creation" do
    before { visit root_path }

    describe "with invalid information" do

      it "should not create a directory" do
        expect { click_button "Create" }.not_to change(Directory, :count)
      end

      describe "error messages" do
        before { click_button "Create" }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'directory_content', with: "Lorem ipsum" }
      it "should create a directory" do
        expect { click_button "Create" }.to change(Directory, :count).by(1)
      end
    end
  end

  describe "directory destruction" do   

    describe "as correct user" do
      before { FactoryGirl.create(:directory, user: user) }
      before { visit root_path }
      it "should delete a directory" do
        expect { click_link "delete" }.to change(Directory, :count).by(-1)
      end
    end

    describe "as incorrect user" do
      let(:other_user) { FactoryGirl.create(:user, email: "wrong@example.com") }    
      before { FactoryGirl.create(:directory, user: other_user) }
      before { visit root_path }
      it { should_not have_link "delete"}
    end
  end
end