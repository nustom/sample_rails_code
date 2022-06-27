module View
  class AdminStudent
    attr_reader :student

    def initialize(student)
      @student = student
    end

    def full_name
      student.full_name
    end

    def email
      student.user.email
    end

    def usi
      student.usi
    end

    def dob
      student.user.personal_detail.dob
    end

    def phone
      student.user.personal_detail.phone
    end

    def last_login
      format_date(student.user.last_login_at) || format_date(student.user.created_at)
    end

    def registered
      format_date(student.user.created_at)
    end

    def enrolments
      @enrolments ||= EnrolmentList.new(student: student).build_list
    end

    def avetmiss
      return nil if student.avetmiss.nil?
      @avetmiss ||= View::Avetmiss.new(student.avetmiss)
    end

    private

    def format_date(date)
      return nil unless date
      TimezoneService.from_i(date.to_i).to_s(:au_date)
    end
  end
end
