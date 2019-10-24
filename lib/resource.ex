defmodule PushEvents.Resource do
  @moduledoc """
  A fake external resource.
  """
  use GenServer

  @spec start_link(any) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(_), do: GenServer.start_link(__MODULE__, :ok, name: __MODULE__)

  @spec init(any) :: {:ok, any}
  def init(_) do
    # Can make this behave like an external resource that will
    # - timeout randomly
    # - timeout on init while connecting to something (would like to use handle/continue)

    {:ok, %{called: 0}}
  end

  @doc """
  API for the resource
  """
  @spec produce(any) :: :ok
  def produce(events) do
    # A fake call to an external resource
    # Can put timeouts here

    GenServer.call(__MODULE__, {:produce, events}, 6500)

    :ok
  end

  def handle_call({:produce, events}, _from, state) do
    IO.inspect(events, label: "Resource handling events")

    IO.inspect(state.called, label: "Called")

    if state.called == 2 do
      Process.sleep(6000)
    end

    {:reply, :ok, %{state | called: state.called + 1}}
  end
end
