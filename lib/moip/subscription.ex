defmodule MoipEx.Subscription do
    alias MoipEx.{Customer, Plan, Subscription, Request, Response, Error, Config, BillingInfo, CreditCard, DateTime, Date,Invoice,
                  Invoice.Status, SubscriptionResponse, Trial, Coupon, Discount, Duration}

    defstruct [code: nil, amount: nil, payment_method: nil, plan: nil, customer: nil, creation_date: nil, status: nil,
              next_invoice_date: nil, expiration_date: nil, trial: nil, coupon: nil]

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
                          coupon: Coupon.t
                        }

    def create(subscription = %Subscription{}, new_customer \\ false) do
      {:ok,response} = Request.request(:post, Config.assinaturas_url <> "/subscriptions?new_customer=#{new_customer}", Request.to_request_string(subscription))
      case response do
        %HTTPoison.Response{status_code: 201} ->
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
      {:ok,response} = Request.request(:get, Config.assinaturas_url <> "/subscriptions")
      case response do
        %HTTPoison.Response{status_code: 200} ->
          {:ok, %{"subscriptions" => subscriptions}} = Poison.decode(response.body, as: %{"subscriptions" => [%Subscription{
                                                                                                      creation_date: %DateTime{},
                                                                                                      expiration_date: %Date{},
                                                                                                      coupon: %Coupon{discount: %Discount{}, duration: %Duration{}, creation_date: %DateTime{},
                                                                                                      expiration_date: %Date{}}},
                                                                                                      customer: %Customer{billing_info: %BillingInfo{credit_card: %CreditCard{}}},
                                                                                                      plan: %Plan{},
                                                                                                      }]})
          {:ok, subscriptions}
        %HTTPoison.Response{status_code: 400} ->
          case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
            {:ok, moip_response} -> {:error, moip_response}
            _ -> {:error, %Response{errors: [%Error{}]}}
          end
        %HTTPoison.Response{status_code: 401} ->
          {:error,:authentication_error}
      end
    end

    def list_by_customer(customer_code) do
      {:ok,response} = Request.request(:get, Config.assinaturas_url <> "/subscriptions")
      case response do
        %HTTPoison.Response{status_code: 200} ->
          {:ok, %{"subscriptions" => subscriptions}} = Poison.decode(response.body, as: %{"subscriptions" => [%Subscription{
                                                                                                      creation_date: %DateTime{},
                                                                                                      expiration_date: %Date{},
                                                                                                      coupon: %Coupon{discount: %Discount{}, duration: %Duration{}, creation_date: %DateTime{},
                                                                                                      expiration_date: %Date{}}},
                                                                                                      customer: %Customer{billing_info: %BillingInfo{credit_card: %CreditCard{}}},
                                                                                                      plan: %Plan{},
                                                                                                      }]})

          {:ok, Enum.filter(subscriptions, fn(subscription) -> subscription.customer.code == customer_code  end)}
        %HTTPoison.Response{status_code: 400} ->
          case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
            {:ok, moip_response} -> {:error, moip_response}
            _ -> {:error, %Response{errors: [%Error{}]}}
          end
        %HTTPoison.Response{status_code: 401} ->
          {:error,:authentication_error}
      end
    end

    def get(subscription_code) do
      {:ok,response} = Request.request(:get, Config.assinaturas_url <> "/subscriptions/#{subscription_code}")
      case response do
        %HTTPoison.Response{status_code: 200} ->
          {:ok, plan} = Poison.decode(response.body, as: %Subscription{
                                                          creation_date: %DateTime{},
                                                          expiration_date: %Date{},
                                                          next_invoice_date: %Date{},
                                                          coupon: %Coupon{discount: %Discount{}, duration: %Duration{}, creation_date: %DateTime{},
                                                          expiration_date: %Date{}}},
                                                          customer: %Customer{billing_info: %BillingInfo{credit_card: %CreditCard{}}},
                                                          plan: %Plan{},
                                                          trial: %Trial{}
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

    def suspend(subscription_code) do
      {:ok,response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription_code}/suspend")
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

    def activate(subscription_code) do
      {:ok,response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription_code}/activate")
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

    def cancel(subscription_code) do
      {:ok,response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription_code}/cancel")
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

    def cancel_all_by_customer(customer_code) do
      case list_by_customer(customer_code) do
        {:ok,subscriptions} ->
          Enum.map(subscriptions, fn(subscription) ->
            if(subscription.status != "CANCELED") do
              cancel(subscription.code)
            end
          end)
          :ok
        {:error, response} -> {:error, response}
      end

    end

    def change(subscription = %Subscription{}) do
      {:ok,response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription.code}",Request.to_request_string(subscription) )
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

    def associate_coupon(subscription_code, coupon_code) do
      request_body = %{coupon: %{code:  coupon_code}}
      {:ok,response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription_code}",Request.to_request_string(request_body) )
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

    def associate_coupon(subscription_code, coupon_code, plan_code) do
      request_body = %{coupon: %{code:  coupon_code}, plan: %{code:  plan_code}}
      {:ok,response} = Request.request(:put, Config.assinaturas_url <> "/subscriptions/#{subscription_code}",Request.to_request_string(request_body) )
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

    def delete_coupon(subscription_code) do
      {:ok,response} = Request.request(:delete, Config.assinaturas_url <> "/subscriptions/#{subscription_code}/coupon")
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
