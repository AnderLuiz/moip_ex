defmodule MoipEx.Preference do
  alias MoipEx.{Preference,Notification, Response, Error, Request, Config}

  defstruct notification: nil

  @type t :: %__MODULE__{
                        notification: Notification.t
                      }


  def set(preference = %Preference{}) do
    {status,response} = Request.request(:post, Config.assinaturas_url <> "/users/preferences", Request.to_request_string(preference))
    case {status,response} do
      {:ok, %HTTPoison.Response{status_code: 204}} ->
        :ok
      {:ok, %HTTPoison.Response{status_code: 400}} ->
        case Poison.decode(response.body, as: %Response{errors: [%Error{}]}) do
          {:ok, moip_response} -> {:error, moip_response}
          _ -> {:error, %Response{errors: [%Error{}]}}
        end
      {:ok, %HTTPoison.Response{status_code: 401}} ->
        {:error,:authentication_error}
      {:error, error} -> {:error, error}
    end
  end

end
