# frozen_string_literal: true

module Messages
  class ReissuePrescriptionNote
    include Dry::Transaction

    step :process_payment_and_record_and_message

    private

    def process_payment_and_record_and_message(id)
      ActiveRecord::Base.transaction do
        Payments::PaymentProviderFactory.provider.debit(10)
        Payment.create!(
          user: default_patient_user,
          amount: 10
        )

        message = send_lost_script_message_to_admin(id)

        Success(message)
      end
    rescue Payments::FlakyPaymentProvider::PaymentError, ActiveRecord::RecordInvalid => e
      Failure(e)
    end

    def send_lost_script_message_to_admin(id)
      doctor_message = Message.find(id)

      return Failure(:missing_note) unless doctor_message

      Message.create!(
        inbox: User.default_admin.inbox,
        outbox: default_patient_user.outbox,
        body: "I've lost my script for --- #{doctor_message.body} --- from --- #{doctor_message.sender.full_name} ---, Please issue a new one at a charge of €10"
      )
    end

    def default_patient_user
      @default_patient_user ||= User.current(:patient)
    end
  end
end
