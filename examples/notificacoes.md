# Notificações

## Exemplo de controller para receber notificações.
Neste exemplo não está sendo verificado o header 'Authorization' enviado pelo moip. Isto pode ser feito através de um plug.

```elixir
defmodule MyApp.MoipController do
  use MyApp.Web, :controller
  require Logger

  def notification(conn, params = %{"event" => "plan.created", "resource" => plan}) do
    Logger.info "[MOIP NOTIFICATION] plan.created #{plan["code"]}"
    Logger.debug inspect(plan)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "plan.updated", "resource" => plan}) do
    Logger.info "[MOIP NOTIFICATION] plan.updated #{plan["code"]}"
    Logger.debug inspect(plan)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "plan.activated", "resource" => plan}) do
    Logger.info "[MOIP NOTIFICATION] plan.activated #{plan["code"]}"
    Logger.debug inspect(plan)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "plan.inactivated", "resource" => plan}) do
    Logger.info "[MOIP NOTIFICATION] plan.updated #{plan["inactivated"]}"
    Logger.debug inspect(plan)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "subscription.created", "resource" => subscription}) do
    Logger.info "[MOIP NOTIFICATION] subscription.created #{subscription["code"]}"
    Logger.debug inspect(subscription)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "subscription.updated", "resource" => subscription}) do
    Logger.info "[MOIP NOTIFICATION] subscription.updated #{subscription["code"]}"
    Logger.debug inspect(subscription)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "subscription.activated", "resource" => subscription}) do
    Logger.info "[MOIP NOTIFICATION] subscription.activated #{subscription["code"]}"
    Logger.debug inspect(subscription)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "subscription.suspended", "resource" => subscription}) do
    Logger.info "[MOIP NOTIFICATION] subscription.suspended #{subscription["code"]}"
    Logger.debug inspect(subscription)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "subscription.canceled", "resource" => subscription}) do
    Logger.info "[MOIP NOTIFICATION] subscription.canceled #{subscription["code"]}"
    Logger.debug inspect(subscription)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "invoice.created", "resource" => invoice}) do
    Logger.info "[MOIP NOTIFICATION] invoice.created #{invoice["id"]}"
    Logger.debug inspect(invoice)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "invoice.status_updated", "resource" => invoice}) do
    Logger.info "[MOIP NOTIFICATION] invoice.status_updated #{invoice["id"]}"
    Logger.debug inspect(invoice)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "payment.created", "resource" => payment}) do
    Logger.info "[MOIP NOTIFICATION] payment.created #{payment["id"]}"
    Logger.debug inspect(payment)
    #Do something
    send_resp(conn, :no_content, "")
  end

  def notification(conn, params = %{"event" => "payment.status_updated", "resource" => payment}) do
    Logger.info "[MOIP NOTIFICATION] payment.status_updated #{payment["id"]}"
    Logger.debug inspect(payment)
    #Do something
    send_resp(conn, :no_content, "")
  end


  def notification(conn, params) do
    Logger.info "[MOIP NOTIFICATION] not implemented"
    Logger.info inspect(params)
    #Do something
    send_resp(conn, :no_content, "")
  end

end

```
