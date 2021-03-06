defmodule MoipEx.Subscription do
  @moduledoc """
    Representação de uma assinatura
  """

  alias MoipEx.{Customer, Plan, Subscription, Request, Response, Error, Config, BillingInfo, CreditCard, DateTime, Date,Invoice,
                Invoice.Status, SubscriptionResponse, Trial, Coupon, Discount, Duration, Links, Link}


  @doc """
  * :code - Identificador da assinatura na sua aplicação. Até 65 caracteres.
  * :amount - Valor da assinatura (sobrescreve o valor do plano contratado) atenção: o cliente deve estar ciente e de acordo em ser cobrado um valor diferente do plano escolhido
  * :plan - Dados do plano da assinatura
  * :customer - Dados do assinante
  * :payment_method - Método de pagamento. Pode ser CREDIT_CARD ou BOLETO
  * :creation_date - Data de criação da assinatura
  * :next_invoice_date - Data da proxima fatura
  * :status - Status da assinatura. Pode ser Active, suspended, expired,overdue, canceled ou trial
  * :trial - Dados do trial
  * :coupon - Dados do cupon utilizado na assinatura
  * :_links - Links relacionados. Ex: Link para boleto

  """
  defstruct [code: nil, amount: nil, payment_method: nil, plan: nil, customer: nil, creation_date: nil, status: nil,
            next_invoice_date: nil, expiration_date: nil, trial: nil, coupon: nil, _links: nil]


  @enforce_keys [:code, :amount, :plan, :customer]
  @type t :: %__MODULE__{
                        code: String.t,
                        amount: String.t, #Valor da assinatura em centavos (sobrescreve o valor do plano contratado) atenção: o cliente deve estar ciente e de acordo em ser cobrado um valor diferente do plano escolhido.
                        payment_method: String.t,
                        plan: Plan.t,
                        customer: Customer.t,
                        creation_date: DateTime.t,
                        status: String.t, #Active, suspended, expired,overdue, canceled,trial
                        next_invoice_date: Date.t,
                        expiration_date: Date.t,
                        trial: Trial.t,
                        coupon: Coupon.t,
                        _links: Links.t
                      }

  def create(subscription = %Subscription{}, new_customer \\ false) do
    {status,response} = Request.request(:post, Config.assinaturas_url <> "/subscriptions?new_customer=#{new_customer}", Request.to_request_string(subscription))
    case {status,response} do
      {:ok, %{status_code: 201}} ->
        {:ok, moip_response} = Poison.decode(response.body, as: %SubscriptionResponse{
                                                errors: [%Error{}],
                                                alerts: [%Error{}],
                                                creation_date: %DateTime{},
                                                expiration_date: %Date{},
                                                next_invoice_date: %Date{},
                                                invoice: %Invoice{status: %Invoice.Status{}},
                                                customer: %Customer{billing_info: %BillingInfo{credit_card: %CreditCard{}}},
                                                plan: %Plan{}
                                              }
                                            )
      {:ok, %{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok,%HTTPoison.Response{status_code: 401}} ->
        {:error,:authentication_error}
      {:ok, %{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def list do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/subscriptions")
    case {status,response} do
      {:ok, %{status_code: 200}} ->
        {:ok, %{"subscriptions" => subscriptions}} = Poison.decode(response.body, as: %{"subscriptions" => [%Subscription{
                                                                                                    creation_date: %DateTime{},
                                                                                                    expiration_date: %Date{},
                                                                                                    coupon: %Coupon{discount: %Discount{}, duration: %Duration{}, creation_date: %DateTime{},
                                                                                                    expiration_date: %Date{}},
                                                                                                    customer: %Customer{billing_info: %BillingInfo{credit_card: %CreditCard{}}},
                                                                                                    plan: %Plan{},
                                                                                                    _links: %Links{boleto: %Link{}},
                                                                                                    }]})
        {:ok, subscriptions}
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

  def list_by_customer(customer_code) do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/subscriptions")
    case {status,response} do
      {:ok, %{status_code: 200}} ->
        {:ok, %{"subscriptions" => subscriptions}} = Poison.decode(response.body, as: %{"subscriptions" => [%Subscription{
                                                                                                    creation_date: %DateTime{},
                                                                                                    expiration_date: %Date{},
                                                                                                    coupon: %Coupon{discount: %Discount{}, duration: %Duration{}, creation_date: %DateTime{},
                                                                                                    expiration_date: %Date{}},
                                                                                                    customer: %Customer{billing_info: %BillingInfo{credit_card: %CreditCard{}}},
                                                                                                    plan: %Plan{},
                                                                                                    _links: %Links{boleto: %Link{} }
                                                                                                    }]})
        {:ok, Enum.filter(subscriptions, fn(subscription) -> subscription.customer.code == customer_code  end)}
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

  def get(subscription_code) do
    {status,response} = Request.request(:get, Config.assinaturas_url <> "/subscriptions/#{subscription_code}")
    case {status,response} do
      {:ok, %{status_code: 200}} ->
        {:ok, _subscription} = Poison.decode(response.body, as: %Subscription{
                                                        creation_date: %DateTime{},
                                                        expiration_date: %Date{},
                                                        next_invoice_date: %Date{},
                                                        coupon: %Coupon{discount: %Discount{}, duration: %Duration{}, creation_date: %DateTime{},
                                                        expiration_date: %Date{}},
                                                        customer: %Customer{billing_info: %BillingInfo{credit_card: %CreditCard{}}},
                                                        plan: %Plan{},
                                                        trial: %Trial{},
                                                        _links: %Links{boleto: %Link{} }
                                                        })
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

  def suspend(subscription_code) do
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription_code}/suspend")
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
      {:ok,%HTTPoison.Response{status_code: 404}} ->
        {:error,:not_found}
      {:ok, %{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def activate(subscription_code) do
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription_code}/activate")
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

  def cancel(subscription_code) do
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription_code}/cancel")
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
      {:ok, %{status_code: 404} }->
        {:error,:not_found}
      {:ok, %{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def cancel_all_by_customer(customer_code) do
    case list_by_customer(customer_code) do
      {:ok,subscriptions} ->
        Enum.map(subscriptions, fn(subscription) ->
          if subscription.status != "CANCELED" do
            cancel(subscription.code)
          end
        end)
        :ok
      {:error, response} -> {:error, response}
    end

  end

  def change(subscription = %Subscription{}) do
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription.code}",Request.to_request_string(subscription) )
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

  def associate_coupon(subscription_code, coupon_code) do
    request_body = %{coupon: %{code:  coupon_code}}
    {status,response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription_code}",Request.to_request_string(request_body) )
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
        {:error, :not_found}
      {:ok, %{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def associate_coupon(subscription_code, coupon_code, plan_code) do
    request_body = %{coupon: %{code:  coupon_code}, plan: %{code:  plan_code}}
    {status, response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription_code}",Request.to_request_string(request_body) )
    case {status,response} do
      {:ok, %{status_code: 200}} ->
        :ok
      {:ok, %{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %{status_code: 401}} ->
        {:error, :authentication_error}
      {:ok, %{status_code: 404}} ->
        {:error, :not_found}
      {:ok, %{status_code: status_code}} -> {:error, status_code}
      {:error, error} -> {:error, error}
    end
  end

  def delete_coupon(subscription_code) do
    {status,response} = Request.request(:delete, Config.assinaturas_url <> "/subscriptions/#{subscription_code}/coupon")
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
