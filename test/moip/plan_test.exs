defmodule MoipEx.PlanTest do
  use ExUnit.Case

  import Mock
  alias MoipEx.{Plan, Example, PlanMock, Request}

  describe "plans" do
    test "create plan successfully" do
      with_mock Request, [request: fn(_atom, _binary, _term) -> PlanMock.create() end, to_request_string: fn(struct) -> MoipEx.PlanMock.to_request_string(struct) end] do
         assert {:ok, %{errors: nil, message: "Plano criado com sucesso"}} = Plan.create(Example.plan("PLAN_CODE"))
      end
    end
  end

end
