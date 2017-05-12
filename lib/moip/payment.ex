defmodule MoipEx.Payment do
  alias MoipEx.{Payment,Payment.Status,Payment.Method, DateTime, CreditCard, Response, Error, Config, Request}

  defstruct [id: nil, moip_id: nil, status: nil, payment_method: nil, creation_date: nil]

  @type t :: %__MODULE__{
                        id: integer, #Identificador do pagamento no Moip Assinaturas.
                        moip_id: integer, #Identificador do pagamento no Moip Pagamentos.
                        status: Payment.Status.t,
                        payment_method: Payment.Method.t,
                        creation_date: DateTime.t
                        }


  def list_by_invoice(invoice_id) do
    {:ok,response} = Request.request(:get, Config.assinaturas_url <> "/invoices/#{invoice_id}/payments")
    case response do
      %HTTPoison.Response{status_code: 200} ->
        {:ok, %{"payments" => payments}} = Poison.decode(response.body, as: %{"payments" => [%Payment{
                                                                                                    creation_date: %DateTime{},
                                                                                                    status: %Payment.Status{},
                                                                                                    payment_method: %Payment.Method{credit_card: %CreditCard{}}
                                                                                                    }]})
        {:ok, payments}
      %HTTPoison.Response{status_code: 400} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      %HTTPoison.Response{status_code: 401} ->
        {:error,:authentication_error}
    end
  end

  def get(payment_id) do
    {:ok,response} = Request.request(:get, Config.assinaturas_url <> "/payments/#{payment_id}")
    case response do
      %HTTPoison.Response{status_code: 200} ->
        {:ok, plan} = Poison.decode(response.body, as: %Payment{
                                                              creation_date: %DateTime{},
                                                              status: %Payment.Status{},
                                                              payment_method: %Payment.Method{credit_card: %CreditCard{}}
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

end
