require 'rails_helper'

describe 'client admin dashboard > divisions tab >' do
  let(:user) { create(:client_admin_user) }
  let(:client) { user.client }
  let(:division) { create(:division, client: client) }

  before do
    login_user(user)
  end

  it 'xxx' do
    visit admin_client_division_path(division)
    click_on 'Managers'
    expect(page).to have_current_path admin_client_division_managers_path(division)
  end

  describe 'managers tab >' do
    before do
      visit admin_client_division_managers_path(division)
    end

    describe 'create internal manager >' do
      before do
        click_on 'open-new-manager-modal'
      end

      it 'can create internal manager' do
        fill_in 'Specify an email address for this manager', with: 'luckybob@yopmail.com'
        fill_in 'First name', with: 'Lucky'
        fill_in 'Last name', with: 'Bob'
        click_on 'create-client-manager'

        new_division_manager = division.internal_managers.first.user
        expect(new_division_manager.email).to eq('luckybob@yopmail.com')
        expect(new_division_manager.full_name).to eq('Lucky Bob')
      end

      it 'can not create internal manager' do
        fill_in 'First name', with: 'Lucky'
        fill_in 'Last name', with: 'Bob'
        click_on 'create-client-manager'

        expect(division.internal_managers.size).to eq(0)
      end
    end

    describe 'create external manager >' do
      before do
        click_on 'add-manager'
      end
    end
  end
end
