require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: I18n.t(:sign_in) ) }
    it { should have_selector('title', text: I18n.t(:sign_in) ) }
  end

  describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button I18n.t(:sign_in) }

      it { should have_selector('title', text: I18n.t(:sign_in) ) }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }
      it { should_not have_link( I18n.t(:profile) ) }
      it { should_not have_link( I18n.t(:settings) ) }

      describe "after visiting another page" do
        before { click_link I18n.t(:home) }
        it { should_not have_selector('div.alert.alert-error') }
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title', text: user.name) }

      it { should have_link( I18n.t(:users) ,    href: users_path) }
      it { should have_link( I18n.t(:profile) ,  href: user_path(user)) }
      it { should have_link( I18n.t(:settings) , href: edit_user_path(user)) }
      it { should have_link( I18n.t(:sign_out), href: signout_path) }

      it { should_not have_link( I18n.t(:sign_in), href: signin_path) }
    end
  end

  describe "authorization" do

    describe "for non-signed-in users" do
      let(:user) { FactoryGirl.create(:user) }

      describe "in the Users controller" do

        describe "visiting the edit page" do
          before { visit edit_user_path(user) }
          it { should have_selector('title', text:  I18n.t(:sign_in) ) }
        end

        describe "submitting to the update action" do
          before { put user_path(user) }
          specify { response.should redirect_to(signin_path) }
        end

        describe "visiting the user index" do
          before { visit users_path }
          it { should have_selector('title', text: I18n.t(:sign_in) ) }
        end
      end

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email",    with: user.email
          fill_in "Password", with: user.password
          click_button I18n.t(:sign_in)
        end

        describe "after signing in" do

          it "should render the desired protected page" do
            page.should have_selector('title', text: I18n.t(:edit_user) )
          end

          describe "when signing in again" do
            before do
              delete signout_path
              visit signin_path
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button I18n.t(:sign_in)
            end

            it "should render the default (profile) page" do
              page.should have_selector('title', text: user.name) 
            end
          end
        end
      end

    end

    describe "for signed in users" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      describe "using a 'new' action" do
        before { get new_user_path }
        specify { response.should redirect_to(root_path) }
      end

      describe "using a 'create' action" do
        before { post users_path }
        specify { response.should redirect_to(root_path) }
      end         
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end
    end

    describe "as non-admin user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:non_admin) { FactoryGirl.create(:user) }

      before { sign_in non_admin }

      describe "submitting a DELETE request to the Users#destroy action" do
        before { delete user_path(user) }
        specify { response.should redirect_to(root_path) }        
      end
    end
  end
end