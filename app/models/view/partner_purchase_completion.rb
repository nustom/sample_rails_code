module View
  class PartnerPurchaseCompletion
    attr_reader :unit, :quantity, :available_completions, :partner_units, :partial_path, :redirect_to, :partner

    def initialize(params)
      @unit = params[:unit]
      @quantity = params[:quantity]
      @available_completions = params[:available_completions]
      @partner_units = params[:partner_units]
      @partial_path = 'partner/purchase/completion'
      @redirect_to = params[:redirect_to]
      @partner = params[:partner]
    end

    def purchase_description
      %(
        Purchasing <strong>#{quantity}</strong> completions for
        <strong>#{unit.name}</strong> at <strong>#{unit.friendly_completion_price}</strong>
        per completion.
      )
    end

    def eway_api_key
      EWAY_PAYMENT_API_KEY
    end

    def price_in_cents
      ((quantity * unit.completion_price) * 100).to_i
    end

    def invoice_description
      "#{partner.company_name} - #{quantity} completions #{unit.name}".truncate(
        63, omission: ''
      )
    end

    def email
      partner.user.email
    end
  end
end
