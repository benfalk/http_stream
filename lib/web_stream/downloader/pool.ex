defmodule WebStream.Downloader.Pool do
  def new do
    %{}
  end

  def downloaded(pool) do
    pool |> filter_by_status(:finished)
  end

  def waiting(pool) do
    pool |> filter_by_status(:waiting)
  end

  def references(pool) do
    pool |> Dict.keys
  end

  def how_many?(pool, status) do
    pool
      |> Dict.values
      |> Enum.filter(fn
           %{ status: x } -> x == status 
           _anything -> false
         end)
      |> Enum.count
  end

  def downloading?(pool) do
    pool
      |> Stream.map(fn {_,v} -> v end)
      |> Enum.any?(fn
           %{ status: :downloading } -> true
           %{ status: :waiting } -> true
           %{ status: _anything } -> false
         end)
  end

  def add(pool, item) do
    Dict.put(pool, item.reference, item)
  end

  def get(pool, ref) do
    Dict.get(pool, ref)
  end

  defp filter_by_status(pool, status) do
    pool
      |> Stream.filter(fn
           {_ref, %{ status: x } } -> x == status
           _anything -> false
         end)
      |> Stream.into(new)
  end
end
