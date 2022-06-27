module View
  class Avetmiss
    attr_reader :avetmiss

    def initialize(avetmiss)
      @avetmiss = avetmiss
    end

    def address
      return nil if avetmiss.nil?
      @address ||= Core::Address.new(
        building_name: avetmiss.residential_building_name,
        unit_details: avetmiss.residential_unit_details,
        street_number: avetmiss.residential_street_number,
        street_name: avetmiss.residential_street_name,
        suburb_name: avetmiss.residential_suburb_name,
        state_identifier: avetmiss.residential_state_identifier,
        post_code: avetmiss.residential_post_code
      )
    end

    def gender_name
      name(avetmiss.gender, :gender_identifiers)
    end

    def origin_country_name
      name(avetmiss.origin_country_identifier, :country_identifiers)
    end

    def language_spoken_name
      name(avetmiss.language_spoken_identifier, :language_identifiers)
    end

    def aboriginal_and_tsi_name
      name(avetmiss.aboriginal_and_tsi_identifier, :aboriginal_and_tsi_identifiers)
    end

    def completed_school_level_name
      name(avetmiss.completed_school_level_identifier, :school_level_identifiers)
    end

    def employment_name
      name(avetmiss.employment_identifier, :employment_identifiers)
    end

    def study_reason_name
      name(avetmiss.study_reason_identifier, :study_reason_identifiers)
    end

    def previous_qualification_names
      avetmiss.previous_qualification_identifiers.map do |id|
        name(id, :qualification_identifiers)
      end.join(', ')
    end

    def disability_names
      avetmiss.disability_identifiers.map do |id|
        name(id, :disability_identifiers)
      end.join(', ')
    end

    def secondary_enrolment_name
      avetmiss.secondary_enrolment_flag ? 'Yes' : 'No'
    end

    private

    def name(code, map)
      AvetmissMap.code_to_name(code, map) || '-'
    end
  end
end
