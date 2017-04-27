defmodule MoipEx.Error do

  defstruct [code: nil, description: nil]

  @type t :: %__MODULE__{
                        code: String.t,
                        description: String.t,
                        }
end
