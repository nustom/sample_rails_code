module View
  class ProcessUnitEvidence
    attr_reader :unit_evidence

    def initialize(unit_evidence)
      @unit_evidence = unit_evidence
      validate_unit_evidence
    end

    def evidence_tally
      "#{completed_evidence_count}/#{total_evidence_count}"
    end

    def evidence_tally_percentage
      (completed_evidence_count.to_f / total_evidence_count.to_f) * 100
    end

    def all_evidence
      unit_evidence
    end

    def evidence_complete?
      completed_evidence_count == total_evidence_count
    end

    private

    def validate_unit_evidence
      raise_evidence_result_error unless evidence_valid?
    end

    def evidence_valid?
      unit_evidence.all? { |ce| ce.is_a? Core::EvidenceResult }
    end

    def raise_evidence_result_error
      raise(
        Errors::Validation, 'Only Core::EvidenceResult models can be provided'
      )
    end

    def completed_evidence_count
      unit_evidence.select(&:evidence_complete).count
    end

    def total_evidence_count
      unit_evidence.count
    end
  end
end
