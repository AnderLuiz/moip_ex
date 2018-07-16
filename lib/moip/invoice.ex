defmodule MoipEx.Invoice do
  @moduledoc """
    Representação de uma fatura
  """
  alias MoipEx.{Config,Subscription,Plan,Customer,Invoice.Status, Request, Response, Error, Invoice, DateTime,Invoice.Item, Links, Link, Coupon, Discount}

  @doc """
  * :id - Identificador da fatura
  * :amount - Valor total cobrado do cliente, em centavos
  * :status - Status da fatura
  * :creation_date - Data de criação da fatura
  * :due_date - Vencimento do boleto, se aplicável
  * :occurrence - Ocorrência da fatura na assinatura (ex. 3 para a terceira fatura)
  * :subscription_code - Codigo da assinatura associada
  * :customer - Assinante que deve pagar a fatura.
  * :items - Itens da fatura.
  * :plan - Plano a ser pago.
  * :coupon - Cupon de desconto associado a fatura.
  * :_links - Links relacionados a fatura. Ex: link para boleto.

  """
  defstruct [amount: nil, status: nil, creation_date: nil, due_date: nil, id: nil, occurrence: nil, subscription_code: nil, customer: nil, items: nil, plan: nil,coupon: nil,_links: nil]

  @type t :: %__MODULE__{
                        amount: integer, #Valor total cobrado do cliente, em centavos.
                        status: Invoice.Status.t,
                        creation_date: DateTime.t,
                        due_date: DateTime.t,
                        id: String.t,
                        items: list(Invoice.Item.t), #Detalhamento dos itens que compõem a fatura
                        subscription_code: String.t,
                        occurrence: integer, #Ocorrência da fatura na assinatura (ex. 3 para a terceira fatura).
                        customer: Customer.t,
                        plan: Plan.t,
                        coupon: Coupon.t,
                        _links: Links.t
                        }


  def list_by_subscription(subscription = %Subscription{}) do
    list_by_subscription(subscription.code)
  end

  def list_by_subscription(subscription_code) do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/subscriptions/#{subscription_code}/invoices")
    case {status,response} do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, %{"invoices" => invoices}} = Poison.decode(response.body, as: %{"invoices" => [%Invoice{
                                                                                                    creation_date: %DateTime{},
                                                                                                    due_date: %DateTime{},
                                                                                                    status: %Invoice.Status{},
                                                                                                    coupon: %Coupon{discount: %Discount{}},
                                                                                                    customer: %Customer{},
                                                                                                    plan: %Plan{},
                                                                                                    items: [%Invoice.Item{}],
                                                                                                    _links: %Links{boleto: %Link{}}
                                                                                                    }]})
        {:ok, invoices}
      {:ok, %HTTPoison.Response{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error,:authentication_error}
      {:ok, %HTTPoison.Response{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def get(invoice_id) do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/invoices/#{invoice_id}")
    case {status,response} do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, plan} = Poison.decode(response.body, as: %Invoice{
                                                          creation_date: %DateTime{},
                                                          due_date: %DateTime{},
                                                          status: %Invoice.Status{},
                                                          coupon: %Coupon{discount: %Discount{}},
                                                          plan: %Plan{},
                                                          customer: %Customer{},
                                                          items: [%Invoice.Item{}],
                                                          _links: %Links{boleto: %Link{}}
                                                        })
      {:ok, %HTTPoison.Response{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error,:authentication_error}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error,:not_found}
      {:ok, %HTTPoison.Response{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def retry(invoice_id) do
    {status,response} = Request.request(:post, Config.assinaturas_url <> "/invoices/#{invoice_id}/retry")
    case {status,response} do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        :ok
      {:ok, %HTTPoison.Response{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error,:authentication_error}
      {:ok, %HTTPoison.Response{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

end
