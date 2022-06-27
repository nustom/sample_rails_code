# Abstract service responsible fore checking application status
class ApplicationStatusService
  attr_reader :target
  def initialize(target)
    @target = target
  end

  def complete?; end

  def css_class
    complete? ? 'complete' : 'incomplete'
  end

  def status
    complete? ? 'Complete' : 'Please Complete'
  end
end
