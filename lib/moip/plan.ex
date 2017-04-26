defmodule MoipEx.Plan do
  defstruct [code: nil, #Identificador do plano na sua aplicação. Até 65 caracteres
            name: nil, #Nome do plano na sua aplicação. Até 65 caracteres
            description: nil, #Descrição do plano na sua aplicação. Até 255 caracteres.
            amount: nil, #Valor do plano a ser cobrado em centavos de Real. obrigatório
            setup_fee: nil, #Taxa de contratação a ser cobrada na assinatura em centavos de Real.
            max_qty: nil, #Quantidade máxima de assinaturas do plano (não há limite se não informar)
            interval: nil, #Node do intervalo do plano, contendo unit e length condicional
            billing_cycles: nil, #Quantidade de ciclos (faturas) que a assinatura terá até expirar (se não informar, não haverá expiração).
            trial: nil, #Node do trial, contendo days e enabled
            status: "ACTIVE", #Status do plano. Pode ser ACTIVE ou INACTIVE. O padrão é ACTIVE.
            payment_method: "CREDIT_CARD"] #Formas de pagamentos aceitas no plano. BOLETO, CREDIT_CARD ou ALL. Caso o atributo não seja informado, a forma de pagamento default é CREDIT_CARD.

  @enforce_keys [:code, :name, :amount]
  @type t :: %__MODULE__{
                        code: String.t,
                        name: String.t,
                        description: String.t,
                        amount: integer,
                        setup_fee: integer,
                        max_qty: integer,
                        interval: Interval.t,
                        billing_cycles: integer,
                        trial: Trial.t,
                        payment_method: String.t
                      }

end
