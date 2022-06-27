module View
  module ProcessBookingShared
    def id
      booking.id
    end

    def name
      booking.student.full_name
    end

    def first_name
      booking.student.first_name
    end

    def unit_name
      booking.session_unit.unit.name
    end

    def email
      booking.student.user.email
    end

    def competency_status
      booking.competency_status
    end

    def competency_notes
      booking.competency_notes
    end

    def student_id
      booking.student&.id
    end

    def student_avetmiss_present?
      booking.student&.avetmiss.present?
    end

    def completion_present?
      booking.partner_completion.present?
    end

    def action_required?
      !student_avetmiss_present?
    end

    def scenario_id
      booking.booking_scenario&.id
    end

    def performance_evidence_id
      booking.booking_performance_evidence&.id
    end
  end
end
