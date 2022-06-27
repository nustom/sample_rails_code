module View
  class PaymentBatchCodeUsage
    attr_reader :id, :range, :client, :usage, :course

    def initialize(args)
      @id      = args[:id]
      @range   = args[:range]
      @client  = args[:client]
      @usage   = args[:usage]
      @course  = args[:course]
    end

    def course_name
      return unless course
      course.name
    end
  end
end
