module View
  class CheckedEnrol
    attr_reader :id, :course,
                :avetmiss_status, :usi_status, :payment_status,
                :avetmiss_required, :usi_required, :payment_required

    def initialize(params)
      @id                = params[:id]
      @course            = params[:course]
      @avetmiss_status   = params[:avetmiss_status]
      @usi_status        = params[:usi_status]
      @payment_status    = params[:payment_status]
      @avetmiss_required = params[:avetmiss_required]
      @usi_required      = params[:usi_required]
      @payment_required  = params[:payment_required]
    end
  end
end
