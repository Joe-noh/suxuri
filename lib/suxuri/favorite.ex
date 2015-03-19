defmodule Suxuri.Favorite do
  @moduledoc ~S"""
  Favorite is similar to "like" in facebook. This module includes only struct
  builder function. The POST interface belongs to `Product` module.
  """

  alias Suxuri.User

  defstruct [:id, :count, :user]

  @type t :: %__MODULE__{}

  @spec new(Map.t) :: t
  def new(%{"id" => id, "count" => count, "user" => user}) do
    %__MODULE__{id: id, count: count, user: User.new(user)}
  end
end
