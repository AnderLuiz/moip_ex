defmodule MoipEx.BillingInfo do
  alias MoipEx.{CreditCard}

  defstruct credit_card: nil, credit_cards: nil

  @type t :: %__MODULE__{
                        credit_card: CreditCard.t, #Dados de cartão de crédito.
                        credit_cards: list(CreditCard.t)
                        }


end
