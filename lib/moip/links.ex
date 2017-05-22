defmodule MoipEx.Links do
  defstruct boleto: nil

  alias MoipEx.Link

  @type t :: %__MODULE__{
                        boleto: Link.t
                      }
end
