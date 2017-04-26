defmodule MoipEx.Example do
  alias MoipEx.{Plan,Trial,Interval}

  def plan do
    %Plan{
      code: "plan-code",
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

end
