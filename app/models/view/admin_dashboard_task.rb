module View
  # This class is used for getting ready of data showing
  # for tasks
  class AdminDashboardTask
    include ActionView::Helpers::DateHelper
    include ActionView::Helpers::TextHelper
    attr_reader :task, :current_user
    def initialize(task, current_user)
      @task = task
      @current_user = current_user
    end

    def friendly_assigned_to
      assigned_to.full_name || assigned_to.email
    end

    def friendly_assigned_by
      assigned_by.full_name || assigned_by.email
    end

    def assigned_at
      TimezoneService.from_i(task.created_at.to_i).to_s(:au_date)
    end

    def friendly_assigned_at
      "#{time_ago_in_words(task.created_at)} ago"
    end

    def due_date
      TimezoneService.parse_local(task.due_at.to_s).to_s(:au_date)
    end

    def due_date_diff
      (TimezoneService.now_local.to_date - task.due_at).to_i
    end

    def friendly_due_date
      return 'Today' if due_date_diff.zero?
      return "in #{due_date_days}" if due_date_diff.negative?
      "#{due_date_days} ago"
    end

    def due_date_days
      pluralize(due_date_diff.abs, 'day')
    end

    def truncated_description
      task.description.truncate(100)
    end

    def task_due?
      task.due_at < TimezoneService.now_local.to_date
    end

    def assigned_to
      @assigned_to ||= task.assigned_to
    end

    def assigned_by
      @assigned_by ||= task.assigned_by
    end

    def own_task?
      assigned_to == current_user
    end
  end
end
