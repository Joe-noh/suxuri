defmodule Suxuri.HTTP do
  @defmodule ~S"""
  This is a wrapper module for HTTPoison.
  """

  alias Suxuri.Config
  alias HTTPoison, as: H

  @base_url "https://suzuri.jp/api/v1"

  def get(path, params \\ []) do
    full(path) |> H.get!(headers, params: params) |> process_response
  end

  def post(path, params) do
    full(path) |> H.post!(JSX.encode!(params), headers) |> process_response
  end

  def put(path, params) do
    full(path) |> H.put!(JSX.encode!(params), headers) |> process_response
  end

  def delete(path, params) do
    full(path) |> H.delete!(JSX.encode!(params), headers) |> process_response
  end

  defp headers do
    %{
      "Authorization" => "Bearer #{Config.access_token}",
      "Content-Type" => "application/json"
    }
  end

  defp full("/" <> path), do: @base_url <> "/" <> path
  defp full(       path), do: @base_url <> "/" <> path

  @doc false
  @spec process_response(%HTTPoison.Response{}) :: {:ok, map} | {:error, term}
  defp process_response(%H.Response{status_code: 200, body: body}) do
    JSX.decode(body)
  end

  defp process_response(%H.Response{status_code: 204}) do
    {:ok, ""}
  end

  defp process_response(%H.Response{status_code: code, body: body}) do
    raise RuntimeError, message: """
    code: #{code}
    body: #{body}
    """
  end
end
