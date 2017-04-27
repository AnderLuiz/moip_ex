defmodule MoipEx.Subscription do
    alias MoipEx.{Customer, Plan, Subscription, Request, Response, Error, Config, BillingInfo, CreditCard, DateTime, Date,Invoice,
                  InvoiceStatus, SubscriptionResponse, Trial}

    defstruct [code: nil, amount: nil, payment_method: nil, plan: nil, customer: nil, creation_date: nil, status: nil,
              next_invoice_date: nil, expiration_date: nil, trial: nil]

    @enforce_keys [:code, :amount, :plan, :customer]
    @type t :: %__MODULE__{
                          code: String.t,
                          amount: String.t, #Valor da assinatura em centavos (sobrescreve o valor do plano contratado) atenção: o cliente deve estar ciente e de acordo em ser cobrado um valor diferente do plano escolhido.
                          payment_method: String.t,
                          plan: Plan.t,
                          customer: Customer.t,
                          creation_date: DateTime.t,
                          status: String.t,
                          next_invoice_date: Date.t,
                          expiration_date: Date.t,
                          trial: Trial.t
                        }

    def create(subscription = %Subscription{}, new_customer \\ false) do
      {:ok,response} = HTTPoison.request(:post,
                        Config.assinaturas_url <> "/subscriptions?new_customer=#{new_customer}",
                        Request.to_request_string(subscription),
                        Request.headers,
                        timeout: :infinity, recv_timeout: :infinity)
      case response do
        %HTTPoison.Response{status_code: 201} ->
          {:ok, moip_response} = Poison.decode(response.body, as: %SubscriptionResponse{
                                                  errors: [%Error{}],
                                                  alerts: [%Error{}],
                                                  creation_date: %DateTime{},
                                                  expiration_date: %Date{},
                                                  next_invoice_date: %Date{},
                                                  invoice: %Invoice{status: %InvoiceStatus{}},
                                                  customer: %Customer{billing_info: %BillingInfo{credit_card: %CreditCard{}}},
                                                  plan: %Plan{}
                                                }
                                              )
        %HTTPoison.Response{status_code: 400} ->
          {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
          {:error, moip_response}
        %HTTPoison.Response{status_code: 401} ->
          {:error,:authentication_error}
      end
    end

    def list do
      {:ok,response} = HTTPoison.request(:get,
                        Config.assinaturas_url <> "/subscriptions",
                        "",
                        Request.headers,
                        timeout: :infinity, recv_timeout: :infinity)
      case response do
        %HTTPoison.Response{status_code: 200} ->
          {:ok, %{"subscriptions" => subscriptions}} = Poison.decode(response.body, as: %{"subscriptions" => [%Subscription{
                                                                                                      creation_date: %DateTime{},
                                                                                                      expiration_date: %Date{},
                                                                                                      customer: %Customer{billing_info: %BillingInfo{credit_card: %CreditCard{}}},
                                                                                                      plan: %Plan{},
                                                                                                      }]})
          {:ok, subscriptions}
        %HTTPoison.Response{status_code: 400} ->
          {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
          {:error, moip_response}
        %HTTPoison.Response{status_code: 401} ->
          {:error,:authentication_error}
      end
    end

    def get(subscription_code) do
      {:ok,response} = HTTPoison.request(:get,
                        Config.assinaturas_url <> "/subscriptions/#{subscription_code}",
                        "",
                        Request.headers,
                        timeout: :infinity, recv_timeout: :infinity)

      case response do
        %HTTPoison.Response{status_code: 200} ->
          {:ok, plan} = Poison.decode(response.body, as: %Subscription{
                                                          creation_date: %DateTime{},
                                                          expiration_date: %Date{},
                                                          next_invoice_date: %Date{},
                                                          customer: %Customer{billing_info: %BillingInfo{credit_card: %CreditCard{}}},
                                                          plan: %Plan{},
                                                          trial: %Trial{}
                                                          })
        %HTTPoison.Response{status_code: 400} ->
          {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
          {:error, moip_response}
        %HTTPoison.Response{status_code: 401} ->
          {:error,:authentication_error}
        %HTTPoison.Response{status_code: 404} ->
          {:error,:not_found}
      end
    end

    def suspend(subscription_code) do
      {:ok,response} = HTTPoison.request(:put,
                        Config.assinaturas_url <> "/subscriptions/#{subscription_code}/suspend",
                        "",
                        Request.headers,
                        timeout: :infinity, recv_timeout: :infinity)
      case response do
        %HTTPoison.Response{status_code: 200} ->
          :ok
        %HTTPoison.Response{status_code: 400} ->
          {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
          {:error, moip_response}
        %HTTPoison.Response{status_code: 401} ->
          {:error,:authentication_error}
        %HTTPoison.Response{status_code: 404} ->
          {:error,:not_found}
      end
    end

    def activate(subscription_code) do
      {:ok,response} = HTTPoison.request(:put,
                        Config.assinaturas_url <> "/subscriptions/#{subscription_code}/activate",
                        "",
                        Request.headers,
                        timeout: :infinity, recv_timeout: :infinity)
      case response do
        %HTTPoison.Response{status_code: 200} ->
          :ok
        %HTTPoison.Response{status_code: 400} ->
          {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
          {:error, moip_response}
        %HTTPoison.Response{status_code: 401} ->
          {:error,:authentication_error}
        %HTTPoison.Response{status_code: 404} ->
          {:error,:not_found}
      end
    end

    def cancel(subscription_code) do
      {:ok,response} = HTTPoison.request(:put,
                        Config.assinaturas_url <> "/subscriptions/#{subscription_code}/cancel",
                        "",
                        Request.headers,
                        timeout: :infinity, recv_timeout: :infinity)
      case response do
        %HTTPoison.Response{status_code: 200} ->
          :ok
        %HTTPoison.Response{status_code: 400} ->
          {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
          {:error, moip_response}
        %HTTPoison.Response{status_code: 401} ->
          {:error,:authentication_error}
        %HTTPoison.Response{status_code: 404} ->
          {:error,:not_found}
      end
    end

    def change(subscription = %Subscription{}) do
      {:ok,response} = HTTPoison.request(:put,
                        Config.assinaturas_url <> "/subscriptions/#{subscription.code}",
                        Request.to_request_string(subscription),
                        Request.headers,
                        timeout: :infinity, recv_timeout: :infinity)
      case response do
        %HTTPoison.Response{status_code: 200} ->
          :ok
        %HTTPoison.Response{status_code: 400} ->
          {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
          {:error, moip_response}
        %HTTPoison.Response{status_code: 401} ->
          {:error,:authentication_error}
        %HTTPoison.Response{status_code: 404} ->
          {:error,:not_found}
      end
    end

    def list_invoices(subscription_code) do
      {:ok,response} = HTTPoison.request(:get,
                        Config.assinaturas_url <> "/subscriptions/#{subscription_code}/invoices",
                        "",
                        Request.headers,
                        timeout: :infinity, recv_timeout: :infinity)
      case response do
        %HTTPoison.Response{status_code: 200} ->
          {:ok, %{"invoices" => subscriptions}} = Poison.decode(response.body, as: %{"invoices" => [%Invoice{
                                                                                                      creation_date: %DateTime{},
                                                                                                      status: %InvoiceStatus{},
                                                                                                      }]})
          {:ok, subscriptions}
        %HTTPoison.Response{status_code: 400} ->
          {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
          {:error, moip_response}
        %HTTPoison.Response{status_code: 401} ->
          {:error,:authentication_error}
      end
    end
end