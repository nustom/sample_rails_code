module View
  class EvidenceTagging
    attr_reader :bookings, :incomplete_student_requirements, :incomplete_unit_requirements, :booking_id

    def initialize(
      bookings:,
      incomplete_student_requirements:,
      incomplete_unit_requirements:,
      booking_id:
    )
      @bookings = bookings
      @incomplete_student_requirements = incomplete_student_requirements || []
      @incomplete_unit_requirements = incomplete_unit_requirements || []
      @booking_id = booking_id
    end

    def booking_selected?
      booking_id.present?
    end
  end
end
