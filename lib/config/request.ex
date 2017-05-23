defmodule MoipEx.Request do
  alias MoipEx.Config

  def headers do
    [
      "Content-Type": "application/json;charset=UTF-8",
      "Accept": "application/json",
      "Authorization": "Basic #{Config.authorization}"
    ]
  end


  def to_request_string(struct, exclude_nil \\ true) do
    {:ok, request_string} = Poison.encode(struct)
    if(exclude_nil == true) do
      removed_null = Regex.replace(~r/\"([^\"]+)\":null(,?)/, request_string, "")
      Regex.replace(~r/,}/, removed_null, "}")
    else
      request_string
    end
  end



  def request(method, path, body \\ "", headers \\ headers ) do
    HTTPoison.request(method,
                      path,
                      body,
                      headers,
                      timeout: 50000, recv_timeout: 50000)
  end

end
