defmodule MoipEx.BillingInfo do
  @moduledoc """
    Representação de informações de cobrança
  """
  
  alias MoipEx.{CreditCard}

  @doc """

  * :credit_card - Dados do cartão de crédito
  * :credit_cards - Cartões de créditos do assinante
  """
  defstruct credit_card: nil, credit_cards: nil

  @type t :: %__MODULE__{
                        credit_card: CreditCard.t, #Dados de cartão de crédito.
                        credit_cards: list(CreditCard.t)
                        }


end
