defmodule MoipEx.CreditCard do
  @moduledoc """
    Representação de um cartão de crédito
  """

  @doc """

  * :holder_name - Nome do portador.
  * :number - Número do cartão de crédito.
  * :expiration_month - Mês de expiração do cartão
  * :expiration_year - Ano de expiração do cartão
  * :vault - Cofre de um cartão de crédito, se já foi cadastrado para este mesmo cliente anteriormente. Caso informe o cofre, os demais dados do cartão não precisam ser informados
  * :brand - Bandeira do cartão
  * :first_six_digits - Primeiros seis digitos
  * :last_four_digits - ultimos 4 digitos
  """

  defstruct [holder_name: nil, number: nil, expiration_month: nil, expiration_year: nil, vault: nil, brand: nil, first_six_digits: nil, last_four_digits: nil]

  @type t :: %__MODULE__{
                        holder_name: String.t,
                        number: String.t,
                        expiration_month: String.t,
                        expiration_year: String.t,
                        brand: String.t,
                        vault: String.t, #Cofre de um cartão de crédito, se já foi cadastrado para este mesmo cliente anteriormente. Caso informe o cofre, os demais dados do cartão não precisam ser informados.
                        first_six_digits: String.t,
                        last_four_digits: String.t
                        }
end
