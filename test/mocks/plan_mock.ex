defmodule MoipEx.PlanMock do
  @moduledoc """
    Mock para testes das requests relacionadas aos planos
  """

  def create() do
    {:ok, successful_create_response()}
  end

  defp successful_create_response() do
    %HTTPoison.Response{
     body: "{\r\n  \"message\": \"Plano criado com sucesso\",\r\n  \"alerts\": [\r\n    {\r\n      \"description\": \"O status do plano deve ser informado. Caso n\u00E3o seja informado, ser\u00E1 considerado ACTIVE\",\r\n      \"code\": \"MA30\"\r\n    }\r\n  ]\r\n}",
     status_code: 201
   }
  end

  def to_request_string(struct, exclude_nil \\ true) do
    {:ok, request_string} = Poison.encode(struct)
    if exclude_nil == true do
      removed_null = Regex.replace(~r/\"([^\"]+)\":null(,?)/, request_string, "")
      Regex.replace(~r/,}/, removed_null, "}")
    else
      request_string
    end
  end
end
