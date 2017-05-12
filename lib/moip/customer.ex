defmodule MoipEx.Customer do
  alias MoipEx.{Config, Request,Customer, Address, BillingInfo, CreditCard, Address, Response, Error}

  defstruct [code: nil, email: nil, fullname: nil, cpf: nil, phone_area_code: nil,
            phone_number: nil, birthdate_day: nil, birthdate_month: nil,
            birthdate_year: nil, address: nil, billing_info: nil]

  @enforce_keys [:code]

  @type t :: %__MODULE__{
                        code: String.t, # Identificador do cliente. Até 65 caracteres..
                        email: String.t, # Email do cliente.
                        fullname: String.t,# Nome completo do cliente. Até 150 caracteres.
                        cpf: String.t, #CPF do cliente. Apenas dígitos numéricos.
                        phone_area_code: String.t,# Código de área do telefone do titular (DDD). 2 carateres sem máscara.
                        phone_number: String.t, #Telefone do titular, 8 ou 9 caracteres sem máscara.
                        birthdate_day: String.t, #Dia do nascimento. Válido 1 a 31.
                        birthdate_month: String.t, #Mês do nascimento. Válido 1 a 12.
                        birthdate_year: String.t, #Ano do nascimento. 4 dígitos.
                        address: Address.t, #Node com os atributos do endereço.
                        billing_info: BillingInfo.t #Dados de pagamento desse cliente.
                      }

  def create(customer = %Customer{}, new_vault \\ true) do
    {:ok,response} = HTTPoison.request(:post,
                      Config.assinaturas_url <> "/customers?new_vault=#{new_vault}",
                      Request.to_request_string(customer),
                      Request.headers,
                      timeout: :infinity, recv_timeout: :infinity)
    case response do
      %HTTPoison.Response{status_code: 201} ->
        {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
      %HTTPoison.Response{status_code: 400} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      %HTTPoison.Response{status_code: 401} ->
        {:error,:authentication_error}
    end
  end

  def list do
    {:ok,response} = HTTPoison.request(:get,
                      Config.assinaturas_url <> "/customers",
                      "",
                      Request.headers,
                      timeout: :infinity, recv_timeout: :infinity)
    case response do
      %HTTPoison.Response{status_code: 200} ->
        {:ok, %{"customers" => plans}} = Poison.decode(response.body, as: %{"customers" => [%Customer{address: %Address{}, billing_info: %BillingInfo{credit_cards: [%CreditCard{}]}}]})
        {:ok, plans}
      %HTTPoison.Response{status_code: 400} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      %HTTPoison.Response{status_code: 401} ->
        {:error,:authentication_error}
    end
  end

  def get(customer_code) do
    {:ok,response} = HTTPoison.request(:get,
                      Config.assinaturas_url <> "/customers/#{customer_code}",
                      "",
                      Request.headers,
                      timeout: :infinity, recv_timeout: :infinity)
    case response do
      %HTTPoison.Response{status_code: 200} ->
        {:ok, plan} = Poison.decode(response.body, as: %Customer{address: %Address{}, billing_info: %BillingInfo{credit_cards: [%CreditCard{}]}})
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

  def change(customer = %Customer{}) do
    {:ok,response} = HTTPoison.request(:put,
                      Config.assinaturas_url <> "/customers/#{customer.code}",
                      Request.to_request_string(customer),
                      Request.headers,
                      timeout: :infinity, recv_timeout: :infinity)
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
      %HTTPoison.Response{status_code: 404} ->
        {:error,:not_found}
    end
  end

  def change_credit_card(customer_code, billing_info = %BillingInfo{}) do
    {:ok,response} = HTTPoison.request(:put,
                      Config.assinaturas_url <> "/customers/#{customer_code}/billing_infos",
                      Request.to_request_string(billing_info),
                      Request.headers,
                      timeout: :infinity, recv_timeout: :infinity)
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
      %HTTPoison.Response{status_code: 404} ->
        {:error,:not_found}
    end
  end
end
