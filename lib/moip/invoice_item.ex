defmodule MoipEx.Invoice.Item do
  @moduledoc """
    Representação de um item de uma fatura
  """

  @doc """

  * :amount - Valor do item, em centavos. Em assinaturas com período de Trial gratuito o valor da primeira fatura é ser 0
  * :type - Descrição do item (ex. "Valor da assinatura", "Taxa de contratação", "Período de Trial", etc.)

  """
  defstruct [amount: nil,
            type: nil]

  @type t :: %__MODULE__{
                        amount: integer,
                        type: String.t
                      }
end
