defmodule MoipEx.Notification do
  alias MoipEx.{Email, Webhook}

  defstruct [webhook: nil, email: nil]

  @type t :: %__MODULE__{
                        webhook: Webhook.t,
                        email: Email.t
                      }

end
