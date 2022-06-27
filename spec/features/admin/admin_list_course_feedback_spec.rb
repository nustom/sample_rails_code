require 'rails_helper'

feature 'Admin list course feedback' do
  let(:admin_user) { create(:admin_user) }
  let(:course) { create(:course_with_live_version) }
  let(:course_version) { course.course_versions.last }

  before do
    login_user(admin_user)
  end

  scenario 'when there are no course enrol with feedback' do
    visit admin_course_edit_feedback_tab_path(course)

    expect(page).to have_content('No feedback found')
  end

  scenario 'when the feedback is positive with a description' do
    enrol = create(:enrol, course_version: course_version)
    feedback = create(:enrol_feedback, :with_upload, enrol: enrol)

    visit admin_course_edit_feedback_tab_path(course)

    expect(page).to have_css('i.fa-smile-o')
    find('i.fa-smile-o').click
    expect(page).to have_content(feedback.description)
  end

  scenario 'when the feedback is positive without a description' do
    enrol = create(:enrol, course_version: course_version)
    create(:enrol_feedback, :with_upload, enrol: enrol, description: nil)

    visit admin_course_edit_feedback_tab_path(course)

    expect(page).to have_css('i.fa-smile-o')
    find('i.fa-smile-o').click
    expect(page).to have_content('No feedback')
  end

  scenario 'when the feedback is negative' do
    enrol = create(:enrol, course_version: course_version)
    create(:enrol_feedback, enrol: enrol, approved: false)

    visit admin_course_edit_feedback_tab_path(course)

    expect(page).to have_css('i.fa-frown-o')
    expect(page).not_to have_css('i.fa-youtube-play')
  end

  scenario 'when the feedback contains a video' do
    enrol = create(:enrol, course_version: course_version)
    create(:enrol_feedback, :with_upload, enrol: enrol)

    visit admin_course_edit_feedback_tab_path(course)

    expect(page).to have_css('i.fa-youtube-play')

    click_link 'View Video Testimonial'

    expect(page).to have_link('Download File')
  end
end
