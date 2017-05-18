defmodule MoipEx.Duration do

  @moduledoc """
    Duração de um cupom
    Type: pode ser once/repeating/forever
    Occurences: Representa o número de ocorrências que receberão o desconto. Válido apenas quando o type for repeating.

  """

  defstruct [type: nil, occurrences: nil]

  @type t :: %__MODULE__{
                        type: String.t,
                        occurrences: integer
                        }

end
