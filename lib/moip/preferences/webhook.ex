defmodule MoipEx.Webhook do

  defstruct [url: nil]

  @type t :: %__MODULE__{
                        url: String.t,
                        }
end
