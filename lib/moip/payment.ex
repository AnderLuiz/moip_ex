defmodule MoipEx.Payment do
  alias MoipEx.{Payment,Payment.Status,Payment.Method, DateTime, CreditCard, Response, Error, Config, Request, Link, Links, Invoice}

  defstruct [id: nil, moip_id: nil, status: nil, payment_method: nil, creation_date: nil, _links: nil, invoice: nil]

  @type t :: %__MODULE__{
                        id: integer, #Identificador do pagamento no Moip Assinaturas.
                        moip_id: integer, #Identificador do pagamento no Moip Pagamentos.
                        status: Payment.Status.t,
                        payment_method: Payment.Method.t,
                        creation_date: DateTime.t,
                        invoice: Invoice.t,
                        _links: Links.t
                        }


  def list_by_invoice(invoice_id) do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/invoices/#{invoice_id}/payments")
    case {status,response} do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, %{"payments" => payments}} = Poison.decode(response.body, as: %{"payments" => [%Payment{
                                                                                                    creation_date: %DateTime{},
                                                                                                    status: %Payment.Status{},
                                                                                                    payment_method: %Payment.Method{credit_card: %CreditCard{}},
                                                                                                    invoice: %Invoice{},
                                                                                                    _links: %Links{boleto: %Link{}}
                                                                                                    }]})
        {:ok, payments}
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

  def get(payment_id) do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/payments/#{payment_id}")
    case {status,response} do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, _payment} = Poison.decode(response.body, as: %Payment{
                                                              creation_date: %DateTime{},
                                                              status: %Payment.Status{},
                                                              payment_method: %Payment.Method{credit_card: %CreditCard{}},
                                                              invoice: %Invoice{},
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

end
