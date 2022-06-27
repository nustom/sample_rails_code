class ManualController < ApplicationController
  def view
    render layout: 'manual'
  end

  def formatted
    render layout: 'application'
  end

  def conference; end

  def page_upload
    render layout: 'manual'
  end
end
