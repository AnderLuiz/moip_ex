defmodule MoipEx.Link do
  defstruct redirect_href: nil

  @type t :: %__MODULE__{
                        redirect_href: String.t
                      }
end
