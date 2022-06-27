class ApplicationMailer < ActionMailer::Base
  default from: 'notifications@apptraining.net.au'
  layout 'mailer'

  def run(command)
    output = command.run
    output.each do |k, v|
      instance_variable_set('@' + k.to_s, v)
    end
  end
end
