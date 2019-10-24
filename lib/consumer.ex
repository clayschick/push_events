defmodule PushEvents.Consumer do
  use GenStage

  @spec start_link(any()) :: :ignore | {:error, any} | {:ok, pid}
  def start_link(opts \\ []) do
    IO.puts("Starting Consumer")

    name = Keyword.get(opts, :name, __MODULE__)

    GenStage.start_link(__MODULE__, name, name: name)
  end

  # @spec init(any) :: {:consumer, any, [{:subscribe_to, [...]}, ...]}
  def init(name) do
    # This will fail to start if the Producer is not available.
    # If a Producer goes down it sends a :cancel signal to the Consumers
    # which terminate with a :shutdown signal. If the Consumer's restart
    # configuration is set to :transient and it receives a :shutdown the
    # Supervisor will not restart it.

    {:consumer, name, subscribe_to: [{PushEvents.Producer, max_demand: 4}]}
  end

  @spec handle_events(any, any, any) :: {:noreply, [], any}
  def handle_events(events, _from, name) do
    # IO.inspect(name, label: "\nConsumer that is handling events")
    # Enum.each(events, &IO.inspect(&1, label: "\nHandling events"))
    Enum.each(events, &IO.puts("#{name} handling event #{&1}"))

    # Call out to a test process that I can jack with
    PushEvents.Resource.produce(events)

    {:noreply, [], name}

    Enum.each(events, &IO.puts(device \\ :stdio, item))
  end
end
