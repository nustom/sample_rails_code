require 'rails_helper'

describe Admin::TaskSearchService do
  let(:user) { create(:admin_user) }
  let(:user_two) { create(:admin_user) }
  let(:params) { {} }

  subject { described_class.new(params).run }

  context 'no search params' do
    let!(:tasks) { create_list(:task, 2) }

    it 'returns all tasks' do
      expect(subject.map(&:id)).to match_array tasks.pluck(:id)
    end
  end

  context 'search by state of the task' do
    let!(:complete_tasks) { create_list(:task, 2, status: :complete) }
    let!(:incomplete_tasks) { create_list(:task, 2, status: :incomplete) }

    context 'complete tasks' do
      let(:params) { { task_state: 'complete' } }
      it 'returns complete tasks' do
        expect(subject.map(&:id)).to match_array complete_tasks.pluck(:id)
      end
    end
    context 'incomplet tasks' do
      let(:params) { { task_state: 'incomplete' } }
      it 'returns incomplete tasks' do
        expect(subject.map(&:id)).to match_array incomplete_tasks.pluck(:id)
      end
    end
  end

  context 'search by assigned to' do
    let!(:user_tasks) { create_list(:task, 2, assigned_to: user) }
    let!(:user_two_tasks) { create_list(:task, 2, assigned_to: user_two) }
    let(:params) { { assigned_to: user.id } }
    it 'returns complete tasks' do
      expect(subject.map(&:id)).to match_array user_tasks.pluck(:id)
    end
  end
end
