defmodule Suxuri.Favorite do
  @moduledoc ~S"""
  Favorite is similar to "like" in facebook. This module includes only struct
  builder function. The POST interface belongs to `Product` module.
  """

  alias Suxuri.User

  defstruct [
    id:    nil,
    count: 0,
    user:  nil
  ]

  @type t :: %__MODULE__{}

  @spec new(Map.t) :: t
  def new(%{"id" => id, "count" => count, "user" => user}) do
    %__MODULE__{id: id, count: count, user: User.new(user)}
  end
end

defimpl Inspect, for: Suxuri.Favorite do
  def inspect(favorite, opts) do
    Suxuri.Inspector.inspect(favorite, :count, [:user], opts)
  end
end
