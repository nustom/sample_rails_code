module View
  ##
  # Groups the interaction between a booking, Core::BookingEvidenceOverview
  # and a Core::BookingCompetencyOverview for a single booking in the
  # course process view.
  #
  # Most of these methods are for convienience, so we do not have to do
  # these filters and equality comparisons from within the view HTML.
  class ProcessBooking
    include View::ProcessBookingShared

    attr_reader :booking, :evidence_overview, :competency_overview

    def initialize(booking, evidence_overview, competency_overview)
      @booking = booking
      @evidence_overview = evidence_overview
      @competency_overview = competency_overview
    end

    def evidence
      @evidence ||= View::ProcessBookingEvidence.new(booking, evidence_overview)
    end

    def can_mark_competent?
      competency_overview.can_mark_competent?
    end

    def competency_determined?
      competency_overview.competency_determined?
    end

    def competent?
      competency_status == 'competent'
    end

    def not_yet_competent?
      competency_status == 'not_yet_competent'
    end

    def avetmiss_present?
      @avetmiss_status ||= AVETMISSCheckService.new(student: booking.student, enrol: booking.enrol,
                                                    check_course_requirement: false).run
      @avetmiss_status.ok?
    end

    def usi_present?
      @usi_status ||= USICheckService.new(student: booking.student, enrol: booking.enrol,
                                          check_course_requirement: false).run
      @usi_status.ok?
    end

    def pac_number
      booking.pac_number
    end

    def raw_pac_number
      return '' unless pac_number.present?
      booking.pac_number.downcase.gsub('pac', '')
    end
  end
end
