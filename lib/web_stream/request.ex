defmodule WebStream.Request do
  defstruct method: nil, url: "", body: "", headers: [], options: []

  def get(url, headers \\ [], options \\ []) do
    %__MODULE__{method: :get, url: url, body: "", headers: headers, options: options}
  end

  def delete(url, headers \\ [], options \\ []) do
    %__MODULE__{method: :delete, url: url, body: "", headers: headers, options: options}
  end

  def head(url, headers \\ [], options \\ []) do
    %__MODULE__{method: :head, url: url, body: "", headers: headers, options: options}
  end

  def options(url, headers \\ [], options \\ []) do
    %__MODULE__{method: :options, url: url, body: "", headers: headers, options: options}
  end

  def patch(url, body, headers \\ [], options \\ []) do
    %__MODULE__{method: :patch, url: url, body: body, headers: headers, options: options}
  end

  def post(url, body, headers \\ [], options \\ []) do
    %__MODULE__{method: :post, url: url, body: body, headers: headers, options: options}
  end

  def put(url, body, headers \\ [], options \\ []) do
    %__MODULE__{method: :put, url: url, body: body, headers: headers, options: options}
  end
end
