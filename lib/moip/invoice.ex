defmodule MoipEx.Invoice do
  alias MoipEx.{Config,Subscription,Plan,Customer,InvoiceStatus, Request, Response, Error, Invoice, DateTime,InvoiceItem}

  defstruct [amount: nil, status: nil, creation_date: nil, id: nil, occurrence: nil, subscription_code: nil, customer: nil, items: nil, plan: nil]

  @type t :: %__MODULE__{
                        amount: integer, #Valor total cobrado do cliente, em centavos.
                        status: InvoiceStatus.t,
                        creation_date: DateTime.t,
                        id: String.t,
                        items: list(InvoiceItem.t), #Detalhamento dos itens que compõem a fatura
                        subscription_code: String.t,
                        occurrence: integer, #Ocorrência da fatura na assinatura (ex. 3 para a terceira fatura).
                        customer: Customer.t,
                        plan: Plan.t,
                        }


  def list_by_subscription(subscription = %Subscription{}) do
    list_by_subscription(subscription.code)
  end

  def list_by_subscription(subscription_code) do
    {:ok,response} = HTTPoison.request(:get,
                      Config.assinaturas_url <> "/subscriptions/#{subscription_code}/invoices",
                      "",
                      Request.headers,
                      timeout: :infinity, recv_timeout: :infinity)
    case response do
      %HTTPoison.Response{status_code: 200} ->
        {:ok, %{"invoices" => invoices}} = Poison.decode(response.body, as: %{"invoices" => [%Invoice{
                                                                                                    creation_date: %DateTime{},
                                                                                                    status: %InvoiceStatus{},
                                                                                                    customer: %Customer{},
                                                                                                    plan: %Plan{},
                                                                                                    items: [%InvoiceItem{}]
                                                                                                    }]})
        {:ok, invoices}
      %HTTPoison.Response{status_code: 400} ->
        {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
        {:error, moip_response}
      %HTTPoison.Response{status_code: 401} ->
        {:error,:authentication_error}
    end
  end

  def get(invoice_id) do
    {:ok,response} = HTTPoison.request(:get,
                      Config.assinaturas_url <> "/invoices/#{invoice_id}",
                      "",
                      Request.headers,
                      timeout: :infinity, recv_timeout: :infinity)
    case response do
      %HTTPoison.Response{status_code: 200} ->
        {:ok, plan} = Poison.decode(response.body, as: %Invoice{
                                                          creation_date: %DateTime{},
                                                          status: %InvoiceStatus{},
                                                          plan: %Plan{},
                                                          customer: %Customer{},
                                                          items: [%InvoiceItem{}]
                                                        })
      %HTTPoison.Response{status_code: 400} ->
        {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
        {:error, moip_response}
      %HTTPoison.Response{status_code: 401} ->
        {:error,:authentication_error}
      %HTTPoison.Response{status_code: 404} ->
        {:error,:not_found}
    end
  end


end
