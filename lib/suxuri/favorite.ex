defmodule Suxuri.Favorite do
  alias Suxuri.User

  defstruct [:id, :count, :user]

  def new(%{"id" => id, "count" => count, "user" => user}) do
    %__MODULE__{id: id, count: count, user: User.new(user)}
  end
end
