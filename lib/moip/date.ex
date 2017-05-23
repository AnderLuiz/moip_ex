defmodule MoipEx.Date do
  @moduledoc """
    Representação de data
  """

  @doc """

  * :year - Ano no formato yyyy
  * :month - Mês no formato MM
  * :day - Dia do mês no formato dd
  """
  defstruct [year: nil, month: nil, day: nil]

  @type t :: %__MODULE__{
                        year: integer,
                        month: integer,
                        day: integer
                      }
end
