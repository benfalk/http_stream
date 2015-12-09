defmodule WebStream.Downloader.PoolItem do
  defstruct status: :waiting,
            task: nil, 
            response: nil,
            request: nil,
            reference: nil,
            downloading?: false

  def new(request) do
    %__MODULE__{request: request, reference: make_ref()}
  end

  def download(item, server, fun) do
    task = Task.async(fn ->
      response = fun.(item.request)
      # I don't like how this knows to ring back
      WebStream.Downloader.update_pool(server, item.reference)
      response
    end)
    %{ item | task: task, status: :downloading, downloading?: true }
  end

  def update(item) do
    response = Task.await(item.task)
    %{ item | response: response, status: :finished, downloading?: false }
  end
end
