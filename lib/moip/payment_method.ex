defmodule MoipEx.Payment.Method do
  alias MoipEx.{CreditCard}

  @moduledoc """
    Representação de um método de pagamento
  """

  @doc """
  * :code - Código identificador do método
  * :description - Descrição do método
  * :credit_card - Dados do Cartão de crédito
  """
  defstruct [code: nil, description: nil, credit_card: nil]

  @type t :: %__MODULE__{
                        code: integer,
                        description: String.t,
                        credit_card: CreditCard.t
                        }

end
