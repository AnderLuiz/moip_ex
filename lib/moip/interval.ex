defmodule MoipEx.Interval do
  defstruct unit: nil,
            length: nil

  @type t :: %__MODULE__{
                        unit: String.t, #A unidade de medida do intervalo de cobrança, o default é MONTH. Opções: DAY, MONTH, YEAR condicional
                        length: integer #A duração do intervalo de cobrança, default é 1 condicional
                      }
end
