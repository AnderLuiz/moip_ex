defmodule MoipEx.Links do
  @moduledoc """
    Representação de vários links
  """

  @doc """
  * :boleto - Link para download do boleto
  """
  defstruct boleto: nil

  alias MoipEx.Link

  @type t :: %__MODULE__{
                        boleto: Link.t
                      }
end
