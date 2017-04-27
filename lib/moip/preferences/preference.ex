defmodule MoipEx.Preference do
  alias MoipEx.{Preference,Notification, Response, Error, Request, Config}

  defstruct notification: nil

  @type t :: %__MODULE__{
                        notification: Notification.t
                      }


  def set(preference = %Preference{}) do
    {:ok,response} = Request.request(:post, Config.assinaturas_url <> "/users/preferences", Request.to_request_string(preference))
    case response do
      %HTTPoison.Response{status_code: 204} ->
        :ok
      %HTTPoison.Response{status_code: 400} ->
        {:ok, moip_response} = Poison.decode(response.body, as: %Response{errors: [%Error{}]})
        {:error, moip_response}
      %HTTPoison.Response{status_code: 401} ->
        {:error,:authentication_error}
    end
  end
  
end
