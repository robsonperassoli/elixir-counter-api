defmodule BroadwayEctoSandbox do
  def attach(repo) do
    events = [
      [:broadway, :processor, :start],
      [:broadway, :batch_processor, :start]
    ]

    :telemetry.attach_many({__MODULE__, repo}, events, &handle_event/4, %{repo: repo})
  end

  def handle_event(_event_name, _event_measurement, %{messages: messages}, %{repo: repo}) do
    with [%Broadway.Message{metadata: %{ecto_sandbox: pid}} | _] <- messages do
      Ecto.Adapters.SQL.Sandbox.allow(repo, pid, self())
    end

    :ok
  end
end

ExUnit.start()
Ecto.Adapters.SQL.Sandbox.mode(Cap.Repo, :manual)

BroadwayEctoSandbox.attach(Cap.Repo)
