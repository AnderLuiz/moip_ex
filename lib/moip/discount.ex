defmodule MoipEx.Discount do

  @moduledoc """
    Desconto de um cupom
    Type: pode ser percent/amount

  """

  defstruct [value: nil, type: nil]

  @type t :: %__MODULE__{
                        value: integer,
                        type: String.t
                        }

end
