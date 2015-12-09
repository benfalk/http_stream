defmodule WebStream.Downloader do
  alias WebStream.Request
  alias WebStream.Downloader.Pool
  alias WebStream.Downloader.PoolItem

  use GenServer

  defstruct downloading?: false,
            pool: Pool.new,
            max_concurrency: 10

  def start_link do
    HTTPoison.start
    GenServer.start_link(__MODULE__, %__MODULE__{})
  end

  def fetch(pid, request) do
    GenServer.cast(pid, {:fetch, request})
  end

  def downloaded(pid) do
    GenServer.call(pid, :downloaded)
  end

  def handle_call(:downloaded, _from, state) do
    {:reply, Pool.downloaded(state.pool), state}
  end

  def update_pool(pid, reference) do
    GenServer.cast(pid, {:update_pool, reference}) 
  end

  def handle_cast({:fetch, request}, state) do
    new_state = state
      |> pool_request(request)
      |> start_downloads
      |> update_downloading_flag
    {:noreply, new_state}
  end

  def handle_cast({:update_pool, reference}, state) do
    new_state = state
      |> pool_update(reference)
      |> start_downloads
      |> update_downloading_flag
    {:noreply, new_state}
  end

  defp start_downloads(state) do
    amount_to_download = state.max_concurrency - Pool.how_many?(state.pool, :downloading)
    update_pool_download(state, amount_to_download)
  end

  defp update_pool_download(state, how_many) when how_many > 0 do
    new_pool = state.pool
      |> Pool.waiting
      |> Enum.take(how_many)
      |> Enum.map(fn { ref, item } ->
           { ref,  item |> PoolItem.download(self(), &make_request/1) }
         end)
      |> Enum.into(state.pool)
    %{ state | pool: new_pool }
  end

  defp update_pool_download(state, how_many) when how_many < 1 do
    state
  end

  defp pool_update(state, reference) do
    updated_item = state.pool
      |> Pool.get(reference)
      |> PoolItem.update
    %{ state | pool: state.pool |> Pool.add( updated_item ) }
  end

  defp pool_request(state, request) do
    %{ state | pool: state.pool |> Pool.add( PoolItem.new(request) ) }
  end

  defp update_downloading_flag(state) do
    %{ state | downloading?: Pool.downloading?(state.pool) }
  end

  defp make_request(%Request{method: method, url: url, body: body, headers: headers, options: options}) do
    HTTPoison.request(method, url, body, headers, options)
  end
end
