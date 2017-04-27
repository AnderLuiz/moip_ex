defmodule MoipEx.Invoice.Item do
  defstruct [amount: nil,
            type: nil]

  @type t :: %__MODULE__{
                        amount: integer, #Valor do item, em centavos. Em assinaturas com período de Trial gratuito o valor da primeira fatura é ser 0
                        type: String.t #Descrição do item (ex. "Valor da assinatura", "Taxa de contratação", "Período de Trial", etc.)
                      }
end
