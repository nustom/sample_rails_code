module View
  class EnrolReport
    attr_reader :id, :student, :student_last_login, :progress_percentage,
                :date_enrolled, :avetmiss_status, :usi_status, :payment_status

    def initialize(params)
      @id                  = params[:id]
      @student             = params[:student]
      @student_last_login  = params[:student_last_login]
      @progress_percentage = params[:progress_percentage]
      @date_enrolled       = params[:date_enrolled]
      @avetmiss_status     = params[:avetmiss_status]
      @usi_status          = params[:usi_status]
      @payment_status      = params[:payment_status]
    end
  end
end
