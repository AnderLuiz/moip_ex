defmodule MoipEx.Discount do
  @moduledoc """
    Desconto dado a uma assinatura
  """

  @doc """

  * :type - Tipo do desconto, pode ser percent ou amount
  * :value - Valor do desconto em porcentagem(%) ou R$

  """
  defstruct [value: nil, type: nil]

  @type t :: %__MODULE__{
                        value: integer,
                        type: String.t
                        }

end
