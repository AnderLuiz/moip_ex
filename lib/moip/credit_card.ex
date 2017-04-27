defmodule MoipEx.CreditCard do

  defstruct [holder_name: nil, number: nil, expiration_month: nil, expiration_year: nil, vault: nil]

  @type t :: %__MODULE__{
                        holder_name: String.t,
                        number: String.t,
                        expiration_month: String.t,
                        expiration_year: String.t,
                        vault: String.t #Cofre de um cartão de crédito, se já foi cadastrado para este mesmo cliente anteriormente. Caso informe o cofre, os demais dados do cartão não precisam ser informados.	
                        }


end
