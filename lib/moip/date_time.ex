defmodule MoipEx.DateTime do
  @moduledoc """
    Representação de data e hora
  """

  @doc """

  * :year - Ano no formato yyyy
  * :month - Mês no formato MM
  * :day - Dia do mês no formato dd
  * :hour - Horas no formato HH (24hs)
  * :minute - Minutos no formato mm
  * :second - Segundos no formato ss

  """
  defstruct [year: nil, month: nil, day: nil, hour: nil, minute: nil, second: nil]

  @type t :: %__MODULE__{
                        year: integer,
                        month: integer,
                        day: integer,
                        hour: integer,
                        minute: integer,
                        second: integer
                      }
end
