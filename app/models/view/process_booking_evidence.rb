module View
  ##
  # A booking in the view needs information from several core models as well as
  # the booking itself so was refactored from the main View::ProcessBooking class.
  #
  # This is so the interaction between a single booking and a
  # Core::BookingEvidenceOverview can all be grouped together into one place,
  # instead of tacking on extra methods in the main class.
  #
  # Most of these methods are for convienience, so we do not have to do
  # these filters from within the view HTML.
  class ProcessBookingEvidence
    attr_reader :booking, :evidence_overview

    def initialize(booking, evidence_overview)
      @booking = booking
      @evidence_overview = evidence_overview
    end

    def tally
      "#{completed_evidence_count}/#{total_evidence_count}"
    end

    def tally_percentage
      (completed_evidence_count.to_f / total_evidence_count.to_f) * 100
    end

    def all
      @all ||= evidence_overview.evidence_results
    end

    def all_for_tagging
      all.reject(&:substitute_with)
    end

    def performance
      @performance ||= all.select { |ev| ev.substitute_with == 'performance_evidence' }
    end

    def performance_complete
      performance.reject(&:evidence_complete).count.zero?
    end

    def simulation
      @simulation ||= all.select { |ev| ev.substitute_with == 'simulation' }
    end

    def simulation_complete
      simulation.reject(&:evidence_complete).count.zero?
    end

    def pending_count
      all.reject(&:evidence_complete).count
    end

    # the evidence does not need to be complete for NYC bookings
    def complete?
      return true if booking.competency_status == 'not_yet_competent'
      completed_evidence_count == total_evidence_count
    end

    private

    def total_evidence_count
      evidence_overview.evidence_results.length
    end

    def completed_evidence_count
      completed_evidence.length
    end

    def completed_evidence
      evidence_overview.evidence_results.select do |result|
        result.evidence_complete == true
      end
    end
  end
end
