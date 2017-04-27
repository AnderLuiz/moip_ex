defmodule MoipEx.DateTime do
  defstruct [year: nil, month: nil, day: nil, hour: nil, minute: nil, second: nil]

  @type t :: %__MODULE__{
                        year: integer, #Ano no formato yyyy
                        month: integer, #Mês no formato MM
                        day: integer, #Dia do mês no formato dd
                        hour: integer, #Horas no formato HH (24hs)
                        minute: integer, #Minutos no formato mm
                        second: integer #Segundos no formato ss
                      }
end
