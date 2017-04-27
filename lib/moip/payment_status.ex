defmodule MoipEx.PaymentStatus do

  @moduledoc """

  Status de um pagamento


  code = 1 = Autorizado = O pagamento foi autorizado pelo banco e pela análise de risco. O valor será creditado de acordo com o prazo de recebimento da sua conta Moip.
  code = 2 = Iniciado = O pagamento foi criado, mas ainda não foi autorizado pelo banco.
  code = 3 = Boleto impresso = O assinante optou pelo pagamento com boleto bancário, mas o banco ainda não confirmou a liquidação do mesmo.Importante: ainda não há pagamento por boleto para o Moip Assinaturas. Esse código não será informado no momento.
  code = 4 = Concluído = O pagamento foi concluído e o valor líquido já está disponível para saque em sua conta Moip.
  code = 5 = Cancelado = O pagamento foi negado pelo banco ou pela análise de risco. Este é um estado final do pagamento.
  code = 6 = Em análise = O pagamento foi autorizado pelo banco e está sendo analisado pelo setor de Análise de Risco. Este é um status temporário com tempo limite de 48 horas.
  code = 7 = Estornado = O pagamento foi revertido pelo banco por solicitação do assinante.
  code = 9 = Reembolsado = O valor foi reembolsado para o assinante por solicitação dele ou do vendedor.
  code = 10 = Aguardando = O Moip ainda está aguardando a confirmação do pagamento. Válido apenas para pagamentos com Boleto Bancário

  """

  defstruct [code: nil, description: nil]

  @type t :: %__MODULE__{
                        code: integer,
                        description: String.t
                        }

end
