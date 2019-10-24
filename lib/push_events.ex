defmodule PushEvents do
  @moduledoc """
  Documentation for PushEvents.
  """
  use Application

  @spec start(any, any) :: {:error, any} | {:ok, pid}
  def start(_type, _args) do
    children = [
      PushEvents.Resource,
      PushEvents.Producer,
      {DynamicSupervisor, name: ConsumerSupervisor, strategy: :one_for_one}
    ]

    IO.inspect(children, label: "Staring children")

    Supervisor.start_link(children, strategy: :rest_for_one)

    DynamicSupervisor.start_child(ConsumerSupervisor, {PushEvents.Consumer, name: C1})

    DynamicSupervisor.start_child(ConsumerSupervisor, {PushEvents.Consumer, name: C2})
  end
end
