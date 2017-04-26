defmodule MoipEx.Interval do
  defstruct [unit: "MONTH", #A unidade de medida do intervalo de cobrança, o default é MONTH. Opções: DAY, MONTH, YEAR condicional
            length: 1] #A duração do intervalo de cobrança, default é 1 condicional

  @type t :: %__MODULE__{
                        unit: String.t,
                        length: integer
                      }
end
