defmodule MoipEx.Customer do
  @moduledoc """
    Representação de um cliente
  """
  alias MoipEx.{Config, Request,Customer, Address, BillingInfo, CreditCard, Address, Response, Error}

  @doc """

  * :code - Identificador do cliente na sua aplicação. Até 65 caracteres
  * :fullname - Nome completo do cliente. Até 150 caracteres
  * :email - Email do cliente
  * :cpf - CPF do cliente
  * :phone_area_code - Código de área do telefone do titular (DDD). 2 carateres
  * :phone_number - Telefone do titular, 8 ou 9 caracteres somente números.
  * :birthdate_day - Dia do nascimento. Válido 1 a 31
  * :birthdate_month - Mês do nascimento. Válido 1 a 12
  * :birthdate_year - Ano do nascimento. 4 dígitos
  * :address - Dados do endereço do cliente
  * :billing_info - Dados do cobrança do cliente
  """
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
    {status,response} = Request.request(:post, Config.assinaturas_url <> "/customers?new_vault=#{new_vault}",Request.to_request_string(customer) )
    case {status,response} do
      {:ok, %{status_code: 201}} ->
        {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
      {:ok, %{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %{status_code: 401}} ->
        {:error,:authentication_error}
      {:ok, %{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def list do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/customers")
    case {status,response} do
      {:ok, %{status_code: 200}} ->
        {:ok, %{"customers" => plans}} = Poison.decode(response.body, as: %{"customers" => [%Customer{address: %Address{}, billing_info: %BillingInfo{credit_cards: [%CreditCard{}]}}]})
        {:ok, plans}
      {:ok, %{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %{status_code: 401}} ->
        {:error,:authentication_error}
      {:ok,%HTTPoison.Response{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def get(customer_code) do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/customers/#{customer_code}")
    case {status,response} do
      {:ok, %{status_code: 200}} ->
        {:ok, _customer} = Poison.decode(response.body, as: %Customer{address: %Address{}, billing_info: %BillingInfo{credit_cards: [%CreditCard{}]}})
      {:ok, %{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %{status_code: 401}} ->
        {:error,:authentication_error}
      {:ok, %{status_code: 404}} ->
        {:error,:not_found}
      {:ok, %{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def change(customer = %Customer{}) do
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/customers/#{customer.code}",Request.to_request_string(customer))
    case {status,response} do
      {:ok, %{status_code: 200}} ->
        :ok
      {:ok, %{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %{status_code: 401}} ->
        {:error,:authentication_error}
      {:ok, %{status_code: 404}} ->
        {:error,:not_found}
      {:ok, %{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def change_credit_card(customer_code, billing_info = %BillingInfo{}) do
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/customers/#{customer_code}/billing_infos",Request.to_request_string(billing_info))
    case {status,response} do
      {:ok, %{status_code: 200}} ->
        :ok
      {:ok, %{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %{status_code: 401}} ->
        {:error,:authentication_error}
      {:ok, %{status_code: 404}} ->
        {:error,:not_found}
      {:ok, %{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end
end
