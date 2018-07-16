defmodule MoipEx.Duration do
  @moduledoc """
    Representação de tempo de duração de um cupom
  """

  @doc """

  * :type - Determina se um coupon será válido apenas em uma cobrança, ou em um número específico diferente de 1 ou em todas. Pode ser once/repeating/forever
  * :occurrences -   * :occurrences - Determina se um coupon será válido apenas em uma cobrança, ou em um número específico diferente de 1 ou em todas. Pode ser percent/amount
  """
  defstruct [type: nil, occurrences: nil]

  @type t :: %__MODULE__{
                        type: String.t,
                        occurrences: integer
                        }

end
