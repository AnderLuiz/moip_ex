defmodule MoipEx.Invoice do
  alias MoipEx.{Config,Subscription,Plan,Customer,Invoice.Status, Request, Response, Error, Invoice, DateTime,Invoice.Item}

  defstruct [amount: nil, status: nil, creation_date: nil, id: nil, occurrence: nil, subscription_code: nil, customer: nil, items: nil, plan: nil]

  @type t :: %__MODULE__{
                        amount: integer, #Valor total cobrado do cliente, em centavos.
                        status: Invoice.Status.t,
                        creation_date: DateTime.t,
                        id: String.t,
                        items: list(Invoice.Item.t), #Detalhamento dos itens que compõem a fatura
                        subscription_code: String.t,
                        occurrence: integer, #Ocorrência da fatura na assinatura (ex. 3 para a terceira fatura).
                        customer: Customer.t,
                        plan: Plan.t,
                        }


  def list_by_subscription(subscription = %Subscription{}) do
    list_by_subscription(subscription.code)
  end

  def list_by_subscription(subscription_code) do
    {:ok,response} = Request.request(:get, Config.assinaturas_url <> "/subscriptions/#{subscription_code}/invoices")
    case response do
      %HTTPoison.Response{status_code: 200} ->
        {:ok, %{"invoices" => invoices}} = Poison.decode(response.body, as: %{"invoices" => [%Invoice{
                                                                                                    creation_date: %DateTime{},
                                                                                                    status: %Invoice.Status{},
                                                                                                    customer: %Customer{},
                                                                                                    plan: %Plan{},
                                                                                                    items: [%Invoice.Item{}]
                                                                                                    }]})
        {:ok, invoices}
      %HTTPoison.Response{status_code: 400} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      %HTTPoison.Response{status_code: 401} ->
        {:error,:authentication_error}
    end
  end

  def get(invoice_id) do
    {:ok,response} = Request.request(:get, Config.assinaturas_url <> "/invoices/#{invoice_id}")
    case response do
      %HTTPoison.Response{status_code: 200} ->
        {:ok, plan} = Poison.decode(response.body, as: %Invoice{
                                                          creation_date: %DateTime{},
                                                          status: %Invoice.Status{},
                                                          plan: %Plan{},
                                                          customer: %Customer{},
                                                          items: [%Invoice.Item{}]
                                                        })
      %HTTPoison.Response{status_code: 400} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      %HTTPoison.Response{status_code: 401} ->
        {:error,:authentication_error}
      %HTTPoison.Response{status_code: 404} ->
        {:error,:not_found}
    end
  end

  def retry(invoice_id) do
    {:ok,response} = Request.request(:post, Config.assinaturas_url <> "/invoices/#{invoice_id}/retry")
    case response do
      %HTTPoison.Response{status_code: 200} ->
        :ok
      %HTTPoison.Response{status_code: 400} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      %HTTPoison.Response{status_code: 401} ->
        {:error,:authentication_error}
    end
  end




end
