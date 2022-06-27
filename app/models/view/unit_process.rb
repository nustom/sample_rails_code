module View
  class UnitProcess
    attr_reader :partner_name, :session_dates, :unit_name, :status, :id, :session_unit_id

    def initialize(params)
      @partner_name      = params[:partner_name]
      @session_dates     = params[:session_dates]
      @unit_name         = params[:unit_name]
      @status            = params[:status]
      @id                = params[:id]
      @session_unit_id = params[:session_unit_id]
    end

    def in_progress?
      status == 'in_progress'
    end

    def submitted?
      status == 'submitted'
    end

    def require_changes?
      status == 'require_changes'
    end

    def rejected?
      status == 'rejected'
    end

    def completed?
      status == 'completed'
    end

    def status_formatted
      case status
      when 'in_progress'
        'In Progress'
      when 'submitted'
        'Submitted'
      when 'require_changes'
        'Changes Required'
      when 'rejected'
        'Rejected'
      when 'completed'
        'Completed'
      end
    end
  end
end
