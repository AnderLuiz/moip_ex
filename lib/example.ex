defmodule MoipEx.Example do
  alias MoipEx.{Plan, Subscription,Trial,Interval, Customer,Address,BillingInfo,CreditCard, Preference, Notification, Email, Email.Config, Coupon, Duration, Discount, Date}

  @moduledoc """
    Modulo de exemplos. Retorna exemplos de planos, assinaturas, cupons, clientes, entre outros.
  """


  def plan(code) do
    %Plan{
      code: code,
      name: "Nome #{code}",
      description: "Descricao do plano #{code}",
      amount: Enum.random(500..9999),
      setup_fee: Enum.random(2000..99999),
      max_qty: Enum.random(500..1000),
      interval: interval(),
      billing_cycles: Enum.random(5..24),
      trial: trial(),
      status: "ACTIVE",
      payment_method: "ALL",
    }
  end

  def plan do
    plan("plan-#{Enum.random(0..99999)}")
  end

  def customer do
    %Customer{
      code: "cliente-#{Enum.random(0..99999)}",
      email: "email@cliente.com.br",
      fullname: "José Castro",
      cpf: "38330516555",
      phone_area_code: "11",
      phone_number: "123456789",
      birthdate_day: "12",
      birthdate_month: "06",
      birthdate_year: "1985",
      address: address(),
      billing_info: billing_info()
    }
  end

  def subscription(plan = %Plan{amount: amount},customer = %Customer{}) do
    %Subscription{
      code: "subscription-#{Enum.random(0..99999)}",
      amount: "#{amount}",
      payment_method: "CREDIT_CARD",
      plan: plan,
      customer: customer
    }
  end

  def subscription(plan = %Plan{}, customer = %Customer{}) do
    %Subscription{
      code: "subscription-#{Enum.random(0..99999)}",
      amount: "510",
      payment_method: "CREDIT_CARD",
      plan: plan,
      customer: customer
    }
  end

  def subscription(plan = %Plan{}) do
    subscription(plan, customer())
  end

  def subscription_with_coupon(subscription = %Subscription{}, coupon_code) do
    Map.put(subscription,:coupon, %Coupon{code: coupon_code})
  end

  def subscription_with_coupon(plan = %Plan{}, coupon_code) do
    Map.put(subscription(plan),:coupon, %Coupon{code: coupon_code})
  end

  def trial do
    %Trial{
      days: 30,
      enabled: false,
      hold_setup_fee: true
    }
  end

  def interval do
    %Interval{
      unit: "MONTH",
      length: 1
    }
  end

  def address do
    %Address{
      street: "Rua Talbate",
      number: "332",
      complement: "Casa",
      district: "Jardim Alemanha",
      city: "São Paulo",
      state: "SP",
      country: "BRA",
      zipcode: "07343634"
    }
  end

  def billing_info do
    %BillingInfo{
      credit_card: credit_card()
    }
  end

  def credit_card do
    %CreditCard{
      holder_name: "João da Silva",
      number: "411111111111#{Enum.random(0..9)}#{Enum.random(0..9)}#{Enum.random(0..9)}#{Enum.random(0..9)}",
      expiration_month: "04",
      expiration_year: "#{Enum.random(25..30)}",
      vault: nil
    }
  end

  def coupon(code) do
    %Coupon{
      code: code,
      name: "coupon-#{code}",
      description: "New coupon #{code}",
      status: "active",
      duration: duration(),
      discount: discount(),
      max_redemptions: 1000,
      expiration_date: expiration_date()
    }
  end

  def coupon do
    coupon("coupon-#{Enum.random(0..99999)}")
  end

  def duration do
    %Duration{
      type: "repeating",
      occurrences: 12
    }
  end

  def discount do
    %Discount{
      value: 1000,
      type: "percent"
    }
  end

  def preference do
    %Preference{
      notification: notification()
    }
  end

  def notification do
    %Notification{
      webhook: "http://exemploldeurl.com.br/assinaturas",
      email: email()
    }
  end

  def email do
    %Email{
      merchant: email_config(),
      customer: email_config()
    }
  end

  def email_config do
    %Email.Config{
      enabled: false
    }
  end

  defp expiration_date do
    %Date{
      year: 2030,
      month: 12,
      day: 26
    }
  end

end
