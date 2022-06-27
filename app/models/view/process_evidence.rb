module View
  class ProcessEvidence
    attr_reader :requirement_name,
                :page_image_url,
                :page_thumb_image_url,
                :page_id,
                :requirement_id,
                :satisfied_by,
                :show_untag,
                :tag_created
    attr_accessor :booking_id, :student_name

    def initialize(params)
      @requirement_name = params[:requirement_name]
      @page_image_url = params[:page_image_url]
      @page_thumb_image_url = params[:page_thumb_image_url]
      @page_id = params[:page_id]
      @requirement_id = params[:requirement_id]
      @satisfied_by = params[:satisfied_by]
      @show_untag = params[:show_untag]
      @booking_id = params[:booking_id]
      @student_name = params[:student_name]
      @tag_created = params[:tag_created]
    end

    def show_untag?
      show_untag
    end
  end
end
