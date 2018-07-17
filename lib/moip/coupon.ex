defmodule MoipEx.Coupon do
  @moduledoc """
    Representação de um cupom de desconto
  """

  @doc """

  * :code - Código do identificador do coupon.
  * :name - Nome do cupom
  * :description - Descrição do cupom
  * :discount - Desconto dado ao cupom
  * :status - Status do cupom, 'active' ou 'inactive'
  * :max_redemptions - Número máximo de submits do coupon até que ele seja inativado automaticamente
  * :expiration_date - Data de inativação do coupon, quando ele não poderá mais ser associado a novas assinaturas
  * :creation_date - Data e hora de criação do cupom
  * :in_use - Informa se o coupon está ou não aplicando suas regras em alguma assinatura.
  """
  defstruct [code: nil, name: nil, description: nil, discount: nil, duration: nil, status: nil, max_redemptions: nil, expiration_date: nil, creation_date: nil, in_use: nil]
  alias MoipEx.{Coupon,Discount, Duration, Date, DateTime, Request, Error, Response, Config}

  @enforce_keys [:code]
  @type t :: %__MODULE__{
                        code: String.t,
                        name: String.t,
                        description: String.t,
                        discount: Discount.t,
                        duration: Duration.t,
                        status: String.t, #active/inactive
                        max_redemptions: integer,
                        expiration_date: Date.t,
                        creation_date: DateTime.t,
                        in_use: nil
                      }

  def create(coupon = %Coupon{}) do
    {status,response} = Request.request(:post, Config.assinaturas_url <> "/coupons", Request.to_request_string(coupon))
    case {status,response} do
      {:ok, %{status_code: 201}} ->
        {:ok, _moip_response} = Poison.decode(response.body, as: %Coupon{discount: %Discount{},
                                                                          duration: %Duration{},
                                                                          creation_date: %DateTime{},
                                                                          expiration_date: %Date{}})
      {:ok, %{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %{status_code: 401}} ->
        {:error,:authentication_error}
      {:error, error} -> {:error, error}
    end
  end

  def list do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/coupons")
    case {status,response} do
      {:ok, %{status_code: 200}} ->
        {:ok, %{"coupons" => coupons}} = Poison.decode(response.body, as: %{"coupons" => [%Coupon{discount: %Discount{},
                                                                                          duration: %Duration{},
                                                                                          creation_date: %DateTime{},
                                                                                          expiration_date: %Date{}}]})
        {:ok, coupons}
      {:ok, %{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %{status_code: 401}} ->
        {:error,:authentication_error}
      {:error, error} -> {:error, error}
    end
  end

  def get(coupon_code) do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/coupons/#{coupon_code}")
    case {status,response} do
      {:ok, %{status_code: 200}} ->
        {:ok, plan} = Poison.decode(response.body, as: %Coupon{discount: %Discount{}, duration: %Duration{}, creation_date: %DateTime{}, expiration_date: %Date{}})
      {:ok, %{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %{status_code: 401}} ->
        {:error,:authentication_error}
      {:ok, %{status_code: 404}} ->
        {:error,:not_found}
      {:error, error} -> {:error, error}
    end
  end

  def get_by_subscription(subscription_code) do
    case MoipEx.Subscription.get(subscription_code) do
      {:ok, subscription} -> {:ok, subscription.coupon}
      {:error, response} -> {:error, response}
    end
  end

  def activate(coupon_code) do
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/coupons/#{coupon_code}/active")
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
      {:error, error} -> {:error, error}
    end
  end

  def inactivate(coupon_code) do
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/coupons/#{coupon_code}/inactive")
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
      {:error, error} -> {:error, error}
    end
  end

end
