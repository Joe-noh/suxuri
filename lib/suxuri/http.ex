defmodule Suxuri.HTTP do
  @defmodule ~S"""
  This is a wrapper module for HTTPoison.
  """

  alias Suxuri.Config
  alias HTTPoison, as: H

  @base_url "https://suzuri.jp/api/v1"

  # TODO: alignment :P
  def get(path), do: H.get(full(path), headers)
  def get(path, params), do: H.get(full(path), headers, params: params)
  def post(path, params), do: H.post(full(path), JSX.encode!(params), headers)
  def put(path, params), do: H.put(full(path), JSX.encode!(params), headers)
  def delete(path, params), do: H.delete(full(path), JSX.encode!(params), headers)

  defp headers do
    %{
      "Authorization" => "Bearer #{Config.access_token}",
      "Content-Type" => "application/json"
    }
  end

  defp full("/" <> path), do: @base_url <> "/" <> path
  defp full(       path), do: @base_url <> "/" <> path
end
