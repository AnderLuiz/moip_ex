defmodule MoipEx do
  alias MoipEx.{Plan,Config, Request,Response}

  def create_plan(plan = %Plan{}) do
    {:ok,response} = HTTPoison.request(:post,
                      Config.assinaturas_url <> "/plans",
                      Request.to_request_string(plan),
                      Request.headers,
                      timeout: :infinity, recv_timeout: :infinity)
    case response do
      %HTTPoison.Response{status_code: 201} ->
        {:ok, moip_response} = Poison.decode(response.body, as: %MoipEx.Response{})
      %HTTPoison.Response{status_code: 400} ->
        {:ok, moip_response} = Poison.decode(response.body, as: %MoipEx.Response{})
        {:error, moip_response}
      %HTTPoison.Response{status_code: 401} ->
        {:error,:authentication_error}
    end
  end
end
