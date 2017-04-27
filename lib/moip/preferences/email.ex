defmodule MoipEx.Email do
  alias MoipEx.{Email.Config}

  defstruct [merchant: nil, customer: nil]

  @type t :: %__MODULE__{
                        merchant: Email.Config.t,
                        customer: Email.Config.t
                        }
end
