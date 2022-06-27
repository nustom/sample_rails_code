module View
  class VideoConferenceRebookingPayment
    attr_reader :course, :quantity, :student, :redirect_to, :video_conference, :purchase_type, :payment_object_params

    def initialize(params)
      @course = params[:course]
      @quantity = params[:quantity]
      @redirect_to = params[:redirect_to]
      @student = params[:student]
      @video_conference = LiveVideoConferenceDecorator.new(params[:video_conference])
      @purchase_type = params[:purchase_type]
      @payment_object_params = { enrol_id: params[:enrol_id], video_conference_id: video_conference.id }
    end

    def purchase_description
      %(
        Purchasing rebooking fee for <strong>#{video_conference.title}</strong>
        for the course <strong>#{course.name}</strong> at
        <strong>#{video_conference.friendly_rebooking_price}</strong>
      )
    end

    def eway_api_key
      EWAY_PAYMENT_API_KEY
    end

    def price_in_cents
      ((quantity * video_conference.rebooking_fee) * 100).to_i
    end

    def invoice_description
      %(
        #{student.full_name} - video conference #{video_conference.title} for #{course.name}
      ).truncate(63, omission: '')
    end

    def email
      student.user.email
    end
  end
end
