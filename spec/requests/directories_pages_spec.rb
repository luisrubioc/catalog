require 'spec_helper'

describe "Directories pages" do

  subject { page }

  let(:user) { FactoryGirl.create(:user) }
  before { sign_in user }

  describe "directories page titles" do
    before { visit directories_path }

    let(:heading) { I18n.t :directories }
    let(:page_title) { I18n.t :directories }

    it { should have_selector('h1',    text: heading) }
    it { should have_selector('title', text: full_title(page_title)) }
  end

  describe "directory creation" do
    before { visit new_directory_path }

    let(:submit) { I18n.t(:create_directory) }

    describe "with invalid information" do

      it "should not create a directory" do
        expect { click_button submit }.not_to change(Directory, :count)
      end

      describe "error messages" do
        before { click_button submit }
        it { should have_content('error') } 
      end
    end

    describe "with valid information" do

      before { fill_in 'directory_name', with: "Lorem ipsum" }
      before { fill_in 'directory_description', with: "Lorem ipsum" }
      it "should create a directory" do
        expect { click_button submit }.to change(Directory, :count).by(1)
      end

      describe "after submission" do
        before { click_button submit }

        it { should have_selector('title', text: full_title("Lorem ipsum") ) }
        it { should have_selector('h1', text: "Lorem ipsum" ) }
        it { should have_content("Lorem ipsum") }
      end

    end
  end

  describe "directory destruction" do
    before { FactoryGirl.create(:directory, user: user) }
    before { visit directories_path }

    describe "normal deleting" do
      it "should delete a directory" do
        expect { click_link I18n.t(:delete) }.to change(Directory, :count).by(-1)
      end
    end

    describe "submitting a DELETE request to the Directory#destroy action" do
      let(:another_user) { FactoryGirl.create(:user) }
      before { sign_out }
      before { sign_in another_user }
      it "should not be able to delete another user's directory" do
        directory_id = user.directories.first
        expect { delete directory_path(directory_id) }.not_to change(Directory, :count)
      end
    end

  end

end