require 'rails_helper'

describe 'As Client' do
  let(:user) { create(:client_admin_user) }
  let!(:division_1) { create(:division, client_id: user.client.id) }
  let!(:division_1_1) { create(:division, client_id: user.client.id, parent_division_id: division_1.id) }
  let!(:division_1_2) { create(:division, client_id: user.client.id, parent_division_id: division_1.id) }
  let!(:division_1_1_1) { create(:division, client_id: user.client.id, parent_division_id: division_1_1.id) }
  let!(:division_1_2_1) { create(:division, client_id: user.client.id, parent_division_id: division_1_2.id) }
  let!(:division_2) { create(:division, client_id: user.client.id) }

  describe 'can open a division' do
    before do
      login_user(user)
      visit admin_client_divisions_path
    end

    it 'open a root division' do
      click_on "division_link_#{division_1.id}"

      expect(page).to have_current_path admin_client_division_path(division_1)
      expect(page).to have_selector 'h2', text: division_1.name
    end

    it 'open a division and it have no subdivitions' do
      click_on "division_link_#{division_2.id}"

      expect(page).to have_text 'There are no divisions'
    end

    it 'can see all subdivisions' do
      click_on "division_link_#{division_1.id}"

      expect(page).to have_text(division_1_1.name,
                                division_1_2.name,
                                division_1_1_1.name,
                                division_1_2_1.name)
    end

    it "cannot see subdivisions which don't belong to" do
      click_on "division_link_#{division_1.id}"

      expect(page).not_to have_text(division_2.name)
    end

    it 'can back parent division' do
      click_on "division_link_#{division_1_1.id}"
      click_on division_1.name.to_s

      expect(page).to have_current_path admin_client_division_path(division_1.id)
    end

    describe 'can add subdivisions into current division' do
      it 'add a subdivision' do
        click_on "division_link_#{division_1.id}"
        click_on 'create-root-division-for-current-division'

        fill_in 'Specify a Division Name', with: 'Division_1_3'
        click_on 'create-division'

        expect(Division.find_by_name('Division_1_3').present?).to be(true)
      end

      it 'add a sub-division inside this division' do
        click_on "division_link_#{division_1.id}"

        click_on "subdivision_#{division_1_1.id}"

        fill_in 'Specify a Division Name', with: 'Division_1_1_3'
        click_on 'create-division'

        expect(Division.find_by_name('Division_1_1_3').present?).to be(true)
      end
    end
  end
end
