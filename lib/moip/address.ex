defmodule MoipEx.Address do
  defstruct [street: nil, number: nil, complement: nil, district: nil, city: nil, state: nil, country: "BRA", zipcode: nil]

  @enforce_keys [:street, :number, :city, :state, :country, :zipcode ]
  @type t :: %__MODULE__{
                        street: String.t,
                        number: String.t,
                        complement: String.t,
                        district: String.t,
                        city: String.t,
                        state: String.t,
                        country: String.t,
                        zipcode: String.t
                      }


end
