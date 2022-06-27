module View
  class ProcessCompletion
    attr_reader :bookings, :session_unit, :completion_balance, :user_is_partner

    def initialize(params)
      @bookings = params[:bookings]
      @session_unit = params[:session_unit]
      @completion_balance = params[:completion_balance]
      @user_is_partner    = params[:user_is_partner]
    end

    def all_bookings_complete?
      bookings_with_completions.count == bookings.count
    end

    def completions_available?
      completion_balance.available_completions_count.positive?
    end

    def required_completions
      bookings.count - bookings_with_completions.count
    end

    def bookings_with_completions
      bookings.select { |b| b.booking.partner_completion.present? }
    end

    def completions_to_use
      return required_completions if required_less_than_available?
      completion_balance.available_completions_count
    end

    private

    def required_less_than_available?
      required_completions < completion_balance.available_completions_count
    end
  end
end
