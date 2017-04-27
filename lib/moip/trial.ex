defmodule MoipEx.Trial do
  alias MoipEx.{Date}

  defstruct [days: 30, #Número de dias de trial do plano.
            enabled: false, #Determina se o trial está ou não habilitado. Opções: TRUE ou FALSE, default é FALSE.
            hold_setup_fee: true, #Determina se o setup_fee será cobrado antes ou após o período de trial. Opções: TRUE (após) ou FALSE (antes).
            start: nil,
            end: nil,
            ]
  @type t :: %__MODULE__{
                        days: integer,
                        enabled: boolean,
                        hold_setup_fee: boolean,
                        start: Date.t,
                        end: Date.t
                      }
end
