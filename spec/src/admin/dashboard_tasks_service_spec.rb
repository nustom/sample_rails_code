require 'rails_helper'

describe Admin::DashboardTasksService do
  let(:user) { create(:admin_user) }
  let(:user_two) { create(:admin_user) }

  subject { described_class.new(user) }

  context '#tasks_assigned_to_you' do
    let!(:incompleted_task) do
      create(:task, assigned_to: user, assigned_by: user_two, status: :incomplete)
    end

    let!(:task_completed) do
      create(:task, assigned_to: user, assigned_by: user_two, status: :complete)
    end

    it 'returns tasks assigned to you' do
      expect(subject.tasks_assigned_to_you).to match_array(incompleted_task)
    end
  end

  context '#tasks_you_have_assigned' do
    let!(:task_incomplete) do
      create(:task, assigned_to: user_two, assigned_by: user, status: :incomplete)
    end

    let!(:task_completed_over_five_days) do
      create(:task, assigned_to: user_two, assigned_by: user,
                    status: :complete, completed_at: TimezoneService.now_local_backward(8.days))
    end

    let!(:task_completed_within_five_days) do
      create(:task, assigned_to: user_two, assigned_by: user,
                    status: :complete, completed_at: TimezoneService.now_local_backward(4.days))
    end

    it 'returns tasks you have assigned' do
      expect(subject.tasks_you_have_assigned).to match_array([task_incomplete, task_completed_within_five_days])
    end
  end
end
