class EmbeddedBookingsController < ApplicationController
  layout 'embedded'

  def index
    @error_message = ''
    run EmbeddedCommand::EmbeddedBookingsIndex.new(params)
    @next_month_path = month_path(@next_month_range)
    @prev_month_path = month_path(@prev_month_range)
  rescue Errors::NotFound => e
    @error_message = e.message
  end

  def choose_session
    run EmbeddedCommand::EmbeddedBookingsChooseSession.new(params)
  end

  def month_path(range)
    embedded_bookings_path(start_date: range[:start], end_date: range[:finish], p_seed: params[:p_seed], c_seed: params[:c_seed])
  end
end
