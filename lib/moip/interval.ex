defmodule MoipEx.Interval do
  @moduledoc """
    Representação de intevalo de cobrança
  """

  @doc """

  * :unit - A unidade de medida do intervalo de cobrança, o default é MONTH. Opções: DAY, MONTH, YEAR condicional
  * :length - A duração do intervalo de cobrança, default é 1 condicional
  """
  defstruct unit: nil,
            length: nil

  @type t :: %__MODULE__{
                        unit: String.t,
                        length: integer
                      }
end
