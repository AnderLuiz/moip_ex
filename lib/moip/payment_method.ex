defmodule MoipEx.PaymentMethod do
  alias MoipEx.{CreditCard}

  defstruct [code: nil, description: nil, credit_card: nil]

  @type t :: %__MODULE__{
                        code: integer,
                        description: String.t,
                        credit_card: CreditCard.t
                        }

end
