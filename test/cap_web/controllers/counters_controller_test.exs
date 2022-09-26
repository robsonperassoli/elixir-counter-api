defmodule Cap.CountersControllerTest do
  use CapWeb.ConnCase

  describe "increment" do
    test "fails when invalid input format", %{conn: conn} do
      conn = post(conn, Routes.counter_path(conn, :increment), %{invalid: true})

      assert json_response(conn, 400)["message"] == "invalid request format"
    end

    test "suceeds when valid json body", %{conn: conn} do
      conn = post(conn, Routes.counter_path(conn, :increment), %{key: "test.counts", value: 12})

      assert conn.resp_body == ""
      assert conn.status == 202
    end
  end
end
