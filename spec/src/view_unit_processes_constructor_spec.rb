require 'rails_helper'

describe ViewUnitProcessesConstructor do
  let(:processes) do
    processes = Array.new(3).map do
      create(:unit_process)
    end
    processes << create(:unit_process, status: 'completed')
    processes
  end

  subject { described_class.new(processes) }

  describe '#run' do
    it 'returns an array of View::UnitProcess' do
      expect(subject.run).to all(be_instance_of(View::UnitProcess))
    end

    it 'has all of the details in the View::UnitProcess' do
      process = subject.run.first
      expect(process.partner_name).to eq(processes.first.session_unit.partner_unit.partnership.company_name)
      expect(process.session_dates).to eq(
        SessionDecorator.new(
          processes.first.session_unit.session
        ).session_dates_formatted
      )
      expect(process.unit_name).to eq(processes.first.session_unit.unit.name)
      expect(process.status_formatted).to eq('In Progress')
      expect(process.status).to eq('in_progress')
      expect(process.id).to eq(processes.first.id)
      expect(process.session_unit_id).to eq(processes.first.session_unit.id)
    end
  end
end
