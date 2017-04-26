defmodule MoipEx.Config do

  @sandbox_url "https://sandbox.moip.com.br/v2/"
  @prod_url "https://moip.com.br/v2/"


  def api_url do
    case Application.get_env(:moip_ex, :env) do
      :sandbox -> @sandbox_url
      _ -> @prod_url
    end
  end


  def token do
    Application.get_env(:moip_ex, :token)
  end

  def api_key do
    Application.get_env(:moip_ex, :key)
  end

  def authorization do
    Base.encode64("#{token}:#{api_key}")
  end
  
end
