defmodule MoipEx.Request do
  alias MoipEx.Config

  def headers do
    [
      "Content-Type": "application/json;charset=ISO-8859-1",
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

end
