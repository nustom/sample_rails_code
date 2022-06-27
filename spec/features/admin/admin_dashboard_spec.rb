require 'rails_helper'

describe 'admin dashboard' do
  let(:admin_user) { create(:admin_user) }
  let(:user)       { create(:user_with_student) }

  it 'does not allow users to access without being signed in' do
    visit admin_root_path
    expect(page).to have_current_path(login_path)
  end

  it 'cannot be reached by non-admin users' do
    login_user(user)
    visit admin_root_path
    expect(page).to have_current_path(learner_root_path)
  end

  it 'can be reached by an admin user' do
    login_user(admin_user)
    visit admin_root_path
    expect(page).to have_current_path(admin_root_path)
  end
end
