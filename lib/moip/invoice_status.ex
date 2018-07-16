defmodule MoipEx.Invoice.Status do
  @moduledoc """
    Status de uma fatura
  """

  @doc """

  Status de uma fatura

  * :code - Código do status da fatura
  code = 1 = Em aberto = A fatura foi gerada mas ainda não foi paga pelo assinante
  code = 2 = Aguardando Confirmação = A fatura foi paga pelo assinante, mas o pagamento está em processo de análise de risco.
  code = 3 = Pago = A fatura foi paga pelo assinante e confirmada.
  code = 4 = Não Pago = O assinante tentou pagar a fatura, mas o pagamento foi negado pelo banco emissor do cartão de crédito ou a análise de risco detectou algum problema. Veja os motivos possíveis.
  code = 5 = Atrasada = O pagamento da fatura foi cancelado e serão feitas novas tentativas de cobrança de acordo com a configuração de retentativa automática.

  * :description - Descrição do status da fatura
  """
  defstruct [code: nil, description: nil]

  @type t :: %__MODULE__{
                        code: integer,
                        description: String.t
                        }

end
