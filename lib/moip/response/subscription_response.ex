defmodule MoipEx.SubscriptionResponse do
  alias MoipEx.{Error, Customer, Plan, Date, DateTime, Invoice}

  defstruct [message: nil, errors: nil, alerts: nil, code: nil, creation_date: nil, customer: nil,
            expiration_date: nil, id: nil, invoice: nil, moip_account: nil, next_invoice_date: nil, payment_method: nil, plan: nil, status: nil]

  @type t :: %__MODULE__{
                        message: String.t,
                        errors: list(Error.t),
                        alerts: list(Error.t),
                        code: String.t,
                        creation_date: DateTime.t,
                        customer: Customer.t,
                        expiration_date: Date.t,
                        id: String.t,
                        invoice: Invoice.t,
                        moip_account: String.t,
                        next_invoice_date: Date.t,
                        payment_method: String.t,
                        plan: Plan.t,
                        status: String.t
                        }
end
