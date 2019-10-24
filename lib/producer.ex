defmodule PushEvents.Producer do
  use GenStage

  @spec start_link(any()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_) do
    IO.puts("Starting Producer")
    GenStage.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  @spec init(any) :: {:producer, []}
  def init(_), do: {:producer, []}

  @spec add(any) :: :ok
  def add(events) do
    # IO.inspect(events, label: "Adding events")
    GenStage.cast(__MODULE__, {:add, events})
  end

  # just push events to consumers on adding
  @spec handle_cast({:add, any}, any) :: {:noreply, [any()], any}
  def handle_cast({:add, events}, state) when is_list(events) do
    # IO.inspect(events, label: "Pushing events list")
    {:noreply, events, state}
  end

  def handle_cast({:add, events}, state) do
    # IO.inspect(events, label: "Pushing events - not a list")
    {:noreply, [events], state}
  end

  # ignore any demand
  @spec handle_demand(pos_integer(), any) :: {:noreply, [], any}
  def handle_demand(demand, state) do
    IO.inspect(demand, label: "Producer handling demand of")
    {:noreply, [], state}
  end
end
