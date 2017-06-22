# MoipEx

[![Hex.pm](https://img.shields.io/hexpm/v/moip_ex.svg?style=plastic)](https://hex.pm/packages/moip_ex)
[![Hex.pm](https://img.shields.io/hexpm/dt/moip_ex.svg?style=plastic)](https://hex.pm/packages/moip_ex)
[![Travis](https://img.shields.io/travis/AnderLuiz/moip_ex.svg?style=plastic)](https://travis-ci.org/AnderLuiz/moip_ex)

Lib para lidar com o moip pagamentos. Até o momento somente com o Moip Assinaturas. https://dev.moip.com.br/v1.5/reference#introdução

# Setup

Para usar o moip_ex no seu projeto:


# 1. Config

```elixir
config :moip_ex,
  token: "TOKEN",
  api_key: "API_KEY",
  env: :sandbox  #ou env: :prod

```

# 2. Mix

```elixir
def deps do
  [{:moip_ex, "~> 0.3.0"}]
end
```

# 3. Exemplos de uso

Para os exemplos a seguir, utilizaremos o Módulo `MoipEx.Example` para obter exemplos de planos, assinaturas, cupons, clientes, etc.


## Planos

#### Exemplo de plano

```elixir
iex(1)> MoipEx.Example.plan()
%MoipEx.Plan{amount: 5440, billing_cycles: 8, code: "PLAN_CODE",
 description: "Descricao do plano", id: nil,
 interval: %MoipEx.Interval{length: 1, unit: "MONTH"}, max_qty: 500,
 name: "Nome do plano", payment_method: "ALL", setup_fee: 55726,
 status: "ACTIVE",
 trial: %MoipEx.Trial{days: 30, enabled: false, end: nil, hold_setup_fee: true,
  start: nil}}
```
Veja documentação do módulo `MoipEx.Plan` para mais detalhes.


### Listar planos
```elixir
  MoipEx.Plan.list()
```

### Criar planos
```elixir
  MoipEx.Plan.create(MoipEx.Example.plan("PLAN_CODE"))
```

### Detalhes de um plano
```elixir
  MoipEx.Plan.get("PLAN_CODE")
```

### Ativar um plano
```elixir
  MoipEx.Plan.activate("PLAN_CODE")
```

### Desativar um plano
```elixir
  MoipEx.Plan.inactivate("PLAN_CODE")
```
### Modificar um plano
```elixir
  MoipEx.Plan.change(MoipEx.Example.plan("PLAN_CODE"))
```

## Clientes

#### Exemplo de cliente

```elixir
iex(1)> MoipEx.Example.customer()
%MoipEx.Customer{address: %MoipEx.Address{city: "São Paulo",
  complement: "Casa", country: "BRA", district: "Jardim Alemanha",
  number: "332", state: "SP", street: "Rua Talbate", zipcode: "07343634"},
 billing_info: %MoipEx.BillingInfo{credit_card: %MoipEx.CreditCard{brand: nil,
   expiration_month: "04", expiration_year: "27", first_six_digits: nil,
   holder_name: "João da Silva", last_four_digits: nil,
   number: "4111111111117756", vault: nil}, credit_cards: nil},
 birthdate_day: "12", birthdate_month: "06", birthdate_year: "1985",
 code: "cliente-46855", cpf: "38330516555", email: "email@cliente.com.br",
 fullname: "José Castro", phone_area_code: "11", phone_number: "123456789"}

```
Veja documentação do módulo `MoipEx.Customer` para mais detalhes.

### Criar cliente

```elixir
  MoipEx.Customer.create(MoipEx.Example.customer())
```

### Listar clientes

```elixir
  MoipEx.Customer.list()
```

### Obter cliente

```elixir
  MoipEx.Customer.get("CUSTOMER_CODE")
```

### Alterar cliente

```elixir
  MoipEx.Customer.change(customer)
```

### Alterar cartao de credito

```elixir
  MoipEx.Customer.change_credit_card("CUSTOMER_CODE", MoipEx.Example.billing_info)
```

## Assinaturas

#### Exemplo de assinatura

```elixir
iex(1)> MoipEx.Example.subscription(plan)   
%MoipEx.Subscription{_links: nil, amount: "1400", code: "subscription-code",
 coupon: nil, creation_date: nil,
 customer: %MoipEx.Customer{address: %MoipEx.Address{city: "São Paulo",
   complement: "Casa", country: "BRA", district: "Jardim Alemanha",
   number: "332", state: "SP", street: "Rua Talbate", zipcode: "07343634"},
  billing_info: %MoipEx.BillingInfo{credit_card: %MoipEx.CreditCard{brand: nil,
    expiration_month: "04", expiration_year: "27", first_six_digits: nil,
    holder_name: "João da Silva", last_four_digits: nil,
    number: "4111111111111247", vault: nil}, credit_cards: nil},
  birthdate_day: "12", birthdate_month: "06", birthdate_year: "1985",
  code: "cliente-code", cpf: "38330516555", email: "email@cliente.com.br",
  fullname: "José Castro", phone_area_code: "11", phone_number: "123456789"},
 expiration_date: nil, next_invoice_date: nil, payment_method: "CREDIT_CARD",
 plan: %MoipEx.Plan{amount: 1400, billing_cycles: 0, code: "plan-code",
  description: "descricao do plano", id: "PLA-CGTZFCA6DCVI",
  interval: %MoipEx.Interval{length: 2, unit: "MONTH"}, max_qty: 0,
  name: "testedffd", payment_method: "CREDIT_CARD", setup_fee: 0,
  status: "INACTIVE",
  trial: %MoipEx.Trial{days: 0, enabled: false, end: nil, hold_setup_fee: true,
   start: nil}}, status: nil, trial: nil}
```
Veja documentação do módulo `MoipEx.Subscription` para mais detalhes.

### Criar assinatura

```elixir
  new_customer = false # or true
  MoipEx.Subscription.create(MoipEx.Example.subscription(plan), new_customer)
```

### Listar assinaturas

```elixir
  MoipEx.Subscription.list()
```
### Listar assinaturas por cliente

```elixir
  MoipEx.Subscription.list_by_customer("CUSTOMER_CODE")
```

### Obter  assinatura

```elixir
  MoipEx.Subscription.get("SUBSCRIPTION_CODE")
```

### Ativar assinatura

```elixir
  MoipEx.Subscription.activate("SUBSCRIPTION_CODE")
```

### Suspender assinatura

```elixir
  MoipEx.Subscription.suspend("SUBSCRIPTION_CODE")
```

### Cancelar assinatura

```elixir
  MoipEx.Subscription.cancel("SUBSCRIPTION_CODE")
```

### Cancelar todas assinaturas de um cliente

```elixir
  MoipEx.Subscription.cancel_all_by_customer("CUSTOMER_CODE")
```

## Cupons

#### Exemplo de cupom

```elixir
iex(1)> MoipEx.Example.coupon()
%MoipEx.Coupon{code: "coupon-abc", creation_date: nil,
 description: "Novo cupom abc",
 discount: %MoipEx.Discount{type: "percent", value: 1000},
 duration: %MoipEx.Duration{occurrences: 12, type: "repeating"},
 expiration_date: %MoipEx.Date{day: 26, month: 12, year: 2030}, in_use: nil,
 max_redemptions: 1000, name: "coupon abc", status: "active"}
```
Veja documentação do módulo `MoipEx.Coupon` para mais detalhes.

### Criar cupom

```elixir
  MoipEx.Coupon.create(MoipEx.Example.coupon())
```

### Listar cupons

```elixir
  MoipEx.Coupon.list()
```

### Obter cupom

```elixir
  MoipEx.Coupon.get("COUPON_CODE")
```
### Obter cupom de uma assinatura

```elixir
  MoipEx.Coupon.get_by_subscription("SUBSCRIPTION_CODE")
```

### Ativar um cupom

```elixir
  MoipEx.Coupon.activate("COUPON_CODE")
```

### Desativar um cupom
```elixir
  MoipEx.Coupon.inactivate("COUPON_CODE")
```


## Faturas

Veja documentação do módulo `MoipEx.Invoice` para mais detalhes


### Listar por assinatura

```elixir
  MoipEx.Invoice.list_by_subscription("SUBSCRIPTION_CODE")
```

### Obter fatura

```elixir
  invoice_id = 333333
  MoipEx.Invoice.get(invoice_id)
```

### Retentativa de cobrança

```elixir
  invoice_id = 3333333
  MoipEx.Invoice.retry(invoice_id)
```


## Pagamentos

Veja documentação do módulo `MoipEx.Payment` para mais detalhes


### Listar por fatura

```elixir
  invoice_id = 3333333
  MoipEx.Payment.list_by_invoice(invoice_id)
```

### Obter pagamento

```elixir
  payment_id = 1111111
  MoipEx.Payment.get(payment_id)
```

## Notificações

[Veja um exemplo de controller para lidar com as notificações MOIP em examples/notifications.md ](notificacoes.html)
