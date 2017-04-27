defmodule MoipEx.InvoiceStatus do

  defstruct [code: nil, description: nil]

  @type t :: %__MODULE__{
                        code: integer,
                        description: String.t
                        }

end
