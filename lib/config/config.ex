defmodule MoipEx.Config do

  @assinaturas_sandbox_url "https://sandbox.moip.com.br/assinaturas/v1"
  @assinaturas_prod_url "https://api.moip.com.br/assinaturas/v1"


  def assinaturas_url do
    case Application.get_env(:moip_ex, :env) do
      :sandbox -> @assinaturas_sandbox_url
      _ -> @assinaturas_prod_url
    end
  end


  def token do
    Application.get_env(:moip_ex, :token)
  end

  def api_key do
    Application.get_env(:moip_ex, :api_key)
  end

  def authorization do
    Base.encode64("#{token}:#{api_key}")
  end

end
