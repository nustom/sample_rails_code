require 'rails_helper'

describe 'Open client admin dashoard' do
  let(:client_admin) { create(:client_admin_user) }

  before do
    login_user(client_admin)
  end

  describe 'in divisions tab' do
    it 'can view my divisions' do
      visit admin_client_root_path
      click_link('Divisions')
      expect(page).to have_current_path admin_client_divisions_path
    end

    before do
      visit admin_client_divisions_path
      click_on 'create-root-division'
    end

    it 'cannot create a division without name', js: true do
      click_on 'create-division'
      expect(Division.first).to be_nil
    end

    describe 'behaviour for a root division' do
      before do
        fill_in 'Specify a Division Name', with: 'Car'
        click_on 'create-division'
      end

      it 'create a root division ' do
        expect(Division.first.name).to eq('Car')
        expect(Division.first.client_id).to eq(client_admin.client.id)
        expect(Division.first.parent_division_id).to be_nil
        expect(page).to have_link(nil, id: 'division_link_1')
        expect(page).to have_link(nil, id: 'subdivision_1')
      end

      it 'redirect to show when click a division' do
        click_on 'division_link_2'
        expect(page).to have_current_path admin_client_division_path(Division.find_by(name: 'Car'))
      end

      context 'behaviour for a sub division' do
        it 'cannot create a subdivision without name', js: true do
          click_on 'subdivision_3'
          click_on 'create-division'

          expect(Division.all.size).to eq(1)
        end

        it 'can create a subdivision' do
          click_on 'subdivision_1'
          fill_in 'Specify a Division Name', with: 'Car-2'
          click_on 'create-division'

          expect(Division.find_by(name: 'Car-2').present?).to be(true)
          expect(Division.find_by(name: 'Car-2').client_id).to eq(client_admin.client.id)
        end
      end
    end
  end
end
