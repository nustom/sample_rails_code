require 'rails_helper'

describe Admin::ManageCertificatesFacade do
  let!(:qualified_booking_one) do
    create(:booking, competency_status: :competent, require_physical_certificate: true)
  end

  let!(:qualified_booking_two) do
    create(:booking, competency_status: :competent, require_wallet_card: true)
  end

  let!(:qualified_booking_three) do
    create(:booking, competency_status: :competent, require_wallet_card: true)
  end

  let!(:qualified_booking_four) do
    create(:booking, competency_status: :competent, require_wallet_card: true)
  end

  let!(:qualified_certificate_queue_one) do
    create(:unit_process_certificate_queue, :processed, booking: qualified_booking_one)
  end

  let!(:qualified_certificate_queue_two) do
    create(:unit_process_certificate_queue, :processed, booking: qualified_booking_two)
  end

  let!(:not_qualified_certificate_queue_two) do
    create(:unit_process_certificate_queue, :pending, booking: qualified_booking_three)
  end

  let!(:not_qualified_certificate_queue_three) do
    create(:unit_process_certificate_queue, :sent, booking: qualified_booking_four)
  end

  describe 'list all bookings awaiting to mark as sent' do
    subject { described_class.new }

    it 'will not list pending or sent certification' do
      expect(mapped_ids(subject.bookings))
        .to contain_exactly(qualified_booking_one.id, qualified_booking_two.id)
    end
  end

  describe 'update certificate as sent' do
    subject { described_class.new(id: qualified_certificate_queue_one.id) }

    it 'mark certificate as sent' do
      subject.update
      qualified_certificate_queue_one.reload
      expect(qualified_certificate_queue_one.status).to eq 'sent'
    end
  end

  def mapped_ids(collection)
    collection.map(&:id).sort
  end
end
