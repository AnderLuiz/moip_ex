defmodule MoipEx.Coupon do
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
    {:ok,response} = Request.request(:post, Config.assinaturas_url <> "/coupons", Request.to_request_string(coupon))
    case response do
      %HTTPoison.Response{status_code: 201} ->
        {:ok, _moip_response} = Poison.decode(response.body, as: %Coupon{discount: %Discount{},
                                                                          duration: %Duration{},
                                                                          creation_date: %DateTime{},
                                                                          expiration_date: %Date{}})
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
    {:ok,response} = Request.request(:get, Config.assinaturas_url <> "/coupons")
    case response do
      %HTTPoison.Response{status_code: 200} ->
        {:ok, %{"coupons" => coupons}} = Poison.decode(response.body, as: %{"coupons" => [%Coupon{discount: %Discount{},
                                                                                          duration: %Duration{},
                                                                                          creation_date: %DateTime{},
                                                                                          expiration_date: %Date{}}]})
        {:ok, coupons}
      %HTTPoison.Response{status_code: 400} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      %HTTPoison.Response{status_code: 401} ->
        {:error,:authentication_error}
    end
  end

  def get(coupon_code) do
    {:ok,response} = Request.request(:get, Config.assinaturas_url <> "/coupons/#{coupon_code}")
    case response do
      %HTTPoison.Response{status_code: 200} ->
        {:ok, plan} = Poison.decode(response.body, as: %Coupon{discount: %Discount{}, duration: %Duration{}, creation_date: %DateTime{}, expiration_date: %Date{}})
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

  def activate(coupon_code) do
    {:ok,response} = Request.request(:put, Config.assinaturas_url <> "/coupons/#{coupon_code}/active")
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

  def inactivate(coupon_code) do
    {:ok,response} = Request.request(:put, Config.assinaturas_url <> "/coupons/#{coupon_code}/inactive")
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
