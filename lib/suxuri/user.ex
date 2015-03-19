defmodule Suxuri.User do
  @moduledoc ~S"""
  This module includes read and update functions for user.
  """

  alias Suxuri.HTTP

  @type t :: %__MODULE__{}

  defmodule Profile do
    defstruct [:url, :body, :header_url]

    def new(%{"url" => url, "body" => body, "headerUrl" => header_url}) do
      %__MODULE__{url: url, body: body, header_url: header_url}
    end

    def new(_), do: nil
  end

  defstruct [:id, :name, :display_name, :avatar_url, :profile]

  @spec new(map) :: __MODULE__.t
  def new(user = %{"id" => id, "name" => name, "displayName" => display_name,
            "avatarUrl" => avatar_url}) do
    profile = Map.get(user, "profile")
    %__MODULE__{id: id, name: name, display_name: display_name,
                avatar_url: avatar_url, profile: Profile.new(profile)}
  end

  @spec get(integer) :: __MODULE__.t
  def get(user_id) do
    HTTP.get!("/users/#{user_id}") |> new_user
  end

  @spec self :: __MODULE__.t
  def self do
    HTTP.get!("/user") |> new_user
  end

  @spec update([Keyword] | map) :: __MODULE__.t
  def update(params) do
    HTTP.put!("/user", params) |> new_user
  end

  @spec update_name(String.t) :: __MODULE__.t
  def update_name(name) when is_binary(name) do
    HTTP.put!("/user", %{"displayName" => name}) |> new_user
  end

  @spec update_avatar(String.t) :: __MODULE__.t
  def update_avatar(url) when is_binary(url) do
    HTTP.put!("/user", %{"avatarUrl" => url}) |> new_user
  end

  @doc false
  @spec new_user(map) :: __MODULE__.t
  defp new_user(%{"user" => user}), do: new(user)
end
