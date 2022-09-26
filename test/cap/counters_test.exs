defmodule Cap.CountersTest do
  use Cap.DataCase

  alias Cap.Counters

  describe "counters" do
    alias Cap.Counters.Count

    test "process_many/1 saves all increments accordingly" do
      increments = [
        %{key: "errors", value: 120},
        %{key: "errors", value: 10},
        %{key: "sockets", value: 150}
      ]

      assert {:ok, _} = Counters.process_many(increments)
    end
  end
end
