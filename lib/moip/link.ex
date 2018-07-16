defmodule MoipEx.Link do
  @moduledoc """
    Representação de um link
  """

  @doc """
  * :redirect_href - Caminho do link (Ex: http://....com)

  """
  defstruct redirect_href: nil


  @type t :: %__MODULE__{
                        redirect_href: String.t
                      }
end
