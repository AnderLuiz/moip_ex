defmodule MoipEx.Example do
  alias MoipEx.{Plan, Subscription,Trial,Interval, Customer,Address,BillingInfo,CreditCard, Preference, Notification, Email, Email.Config}

  def plan(code) do
    %Plan{
      code: code,
      name: "Nome #{code}",
      description: "Descricao do plano #{code}",
      amount: Enum.random(500..9999),
      setup_fee: Enum.random(2000..99999),
      max_qty: Enum.random(500..1000),
      interval: interval,
      billing_cycles: Enum.random(5..24),
      trial: trial,
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
      address: address,
      billing_info: billing_info
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

  def subscription(plan_code,customer = %Customer{}) do
    %Subscription{
      code: "subscription-#{Enum.random(0..99999)}",
      amount: "510",
      payment_method: "CREDIT_CARD",
      plan: plan,
      customer: customer
    }
  end

  def subscription(plan = %Plan{}) do
    subscription(plan, customer)
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
      credit_card: credit_card
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

  def preference do
    %Preference{
      notification: notification
    }
  end

  def notification do
    %Notification{
      webhook: "http://exemploldeurl.com.br/assinaturas",
      email: email
    }
  end

  def email do
    %Email{
      merchant: email_config,
      customer: email_config
    }
  end

  def email_config do
    %Email.Config{
      enabled: false
    }
  end

end
