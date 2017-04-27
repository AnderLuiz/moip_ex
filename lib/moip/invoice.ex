defmodule MoipEx.Invoice do
  alias MoipEx.{InvoiceStatus}

  defstruct [amount: nil, status: nil, id: nil]

  @type t :: %__MODULE__{
                        amount: integer,
                        status: InvoiceStatus.t,
                        id: String.t
                        }

end
