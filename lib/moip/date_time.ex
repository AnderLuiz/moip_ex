defmodule MoipEx.DateTime do
  defstruct [year: nil, month: nil, day: nil, hour: nil, minute: nil, second: nil]

  @type t :: %__MODULE__{
                        year: integer,
                        month: integer,
                        day: integer,
                        hour: integer,
                        minute: integer,
                        second: integer
                      }
end
