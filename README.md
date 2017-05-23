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
  [{:moip_ex, "~> 0.2.7"}]
end
```

# Uso

Para os exemplos a seguir, utilizaremos o Módulo `MoipEx.Example` para obter exemplos de planos, assinaturas, cupons, clientes, etc.

## Planos

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

## Assinaturas

TODO

## Cupons

TODO

## Faturas

TODO

## Pagamentos

TODO
