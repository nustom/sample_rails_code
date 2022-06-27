module View
  class UnitProcessEvidenceReview
    attr_reader :process, :user

    def initialize(process, user)
      @process = process
      @user = user
    end

    def evidence
      @evidence ||= ViewProcessEvidenceConstructor.new(
        process,
        requirements,
        evidence_pages,
        evidence_tags,
        user
      ).run
    end

    def evidence_grid
      @grid ||= evidence.in_groups_of(5).map(&:compact)
    end

    def subtitle
      "for #{unit_name} #{submitted_by}"
    end

    def submitted_by
      "Submitted by #{partner_name}"
    end

    def process_id
      process.id
    end

    def session_unit_id
      process.session_unit.id
    end

    def reject_button_text
      user.admin? ? 'Reject Evidence' : 'Untag Evidence'
    end

    def show_back_tagging?
      process.submitted? || process.rejected?
    end

    private

    def requirements
      @req ||= evidence_repo.find_requirements
    end

    def evidence_tags
      @tagged_pages ||= evidence_repo.find_tags_from_pages(evidence_pages)
    end

    def evidence_pages
      @pages ||= evidence_repo.find_pages_for_process(process)
    end

    def evidence_repo
      Repository::Evidence.new(current_version)
    end

    def current_version
      @version ||= BoundUnitProcessVersion.new(process.session_unit)
                                          .unit_process_version
    end

    def partner_name
      process.session_unit.partner_unit.partnership.company_name
    end

    def unit_name
      process.session_unit.partner_unit.unit.name
    end
  end
end
