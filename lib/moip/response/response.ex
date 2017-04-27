defmodule MoipEx.Response do
  alias MoipEx.{Error}

  defstruct [message: nil, errors: nil]

  @type t :: %__MODULE__{
                        message: String.t,
                        errors: list(Error.t),
                        }
end
