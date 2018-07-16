defmodule MoipEx.Plan do
  @moduledoc """
    Representação de um plano
  """

  alias MoipEx.{Config,Request,Response,Error,Plan,Interval,Trial}

  @doc """
  * :code - Identificador do plano na sua aplicação. Até 65 caracteres
  * :name - Nome do plano na sua aplicação. Até 65 caracteres
  * :description - Descrição do plano na sua aplicação. Até 255 caracteres
  * :amount - Valor do plano a ser cobrado em centavos de Real. obrigatório
  * :setup_fee - Taxa de contratação a ser cobrada na assinatura em centavos de Real
  * :max_qty - Quantidade máxima de assinaturas do plano (não há limite se não informar)
  * :billing_cycles - Quantidade de ciclos (faturas) que a assinatura terá até expirar (se não informar, não haverá expiração)
  * :trial - Dados do trial
  * :status - Status do plano. Pode ser ACTIVE ou INACTIVE. O padrão é ACTIVE
  * :payment_method - Formas de pagamentos aceitas no plano. BOLETO, CREDIT_CARD ou ALL. Caso o atributo não seja informado, a forma de pagamento default é CREDIT_CARD.
  * :id - Identificador do plano moip

  """
  defstruct [code: nil,
            name: nil,
            description: nil,
            amount: nil,
            setup_fee: nil,
            max_qty: nil,
            interval: nil,
            billing_cycles: nil,
            trial: nil,
            status: nil,
            payment_method: nil,
            id: nil]
  @enforce_keys [:code]
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
                        payment_method: String.t,
                        id: String.t
                      }


  def create(plan = %Plan{}) do
    {status,response} =  Request.request(:post, Config.assinaturas_url <> "/plans", Request.to_request_string(plan))
    case {status,response} do
      {:ok, %HTTPoison.Response{status_code: 201}} ->
        {:ok, _moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
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

  def list do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/plans")
    case {status,response} do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, %{"plans" => plans}} = Poison.decode(response.body, as: %{"plans" => [%Plan{trial: %Trial{}, interval: %Interval{}}]})
        {:ok, plans}
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

  def get(plan_code) do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/plans/#{plan_code}")
    case {status,response} do
      {:ok, %HTTPoison.Response{status_code: 200}} ->
        {:ok, _plan} = Poison.decode(response.body, as: %Plan{trial: %Trial{}, interval: %Interval{}})
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

  def activate(plan_code) do
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/plans/#{plan_code}/activate")
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
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error,:not_found}
      {:ok, %HTTPoison.Response{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def inactivate(plan_code) do
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/plans/#{plan_code}/inactivate")
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
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error,:not_found}
      {:ok, %HTTPoison.Response{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def change(plan = %Plan{}) do
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/plans/#{plan.code}", Request.to_request_string(plan))
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
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error,:not_found}
      {:ok, %HTTPoison.Response{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

end
