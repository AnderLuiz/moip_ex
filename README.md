# MoipEx

Em desenvolvimento. Não pronto para produção. Confira a documentação em https://hexdocs.pm/moip_ex/api-reference.html.


# Config

No config.exs, adicione as configuraçoes da conta no moip_ex

```elixir
config :moip_ex,
  token: "TOKEN",
  api_key: "API_KEY",
  env: :sandbox   #ou prod

```

## Installation

```elixir
def deps do
  [{:moip_ex, "~> 0.1.0"}]
end
```
