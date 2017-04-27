defmodule MoipEx.Example do
  alias MoipEx.{Plan,Trial,Interval, Customer,Address,BillingInfo,CreditCard}

  def plan do
    %Plan{
      code: "plan-#{Enum.random(0..9999)}",
      name: "Plano 01",
      description: "Descricao do plano 01",
      amount: 500,
      setup_fee: 299,
      max_qty: 1000,
      interval: interval,
      billing_cycles: 12,
      trial: trial,
      status: "ACTIVE",
      payment_method: "CREDIT_CARD",
    }
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

  def customer do
    %Customer{
      code: "cliente-#{Enum.random(0..9999)}",
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
      number: "4111111111111111",
      expiration_month: "04",
      expiration_year: "23",
      vault: nil
    }
  end

end
