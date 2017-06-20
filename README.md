# MoipEx

Lib para lidar com o moip pagamentos. Até o momento somente com o Moip Assinaturas.

# Setup

Para usar o moip_ex no seu projeto:


## 1. Config

```elixir
config :moip_ex,
  token: "TOKEN",
  api_key: "API_KEY",
  env: :sandbox  #ou prod

```

## 2. Mix

```elixir
def deps do
  [{:moip_ex, "~> 0.2.8"}]
end
```

# Uso

Para os exemplos a seguir, utilizaremos o Módulo `MoipEx.Example` para obter exemplos de planos, assinaturas, cupons, clientes, etc.

## Planos

Veja documentação do módulo `MoipEx.Plan` para mais detalhes

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

Veja documentação do módulo `MoipEx.Customer` para mais detalhes

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
  customer = MoipEx.Customer.get("CUSTOMER_CODE")
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

Veja documentação do módulo `MoipEx.Subscription` para mais detalhes

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

Veja documentação do módulo `MoipEx.Coupon` para mais detalhes

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
