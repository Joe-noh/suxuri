defmodule Suxuri.User do
  @moduledoc ~S"""
  This module includes read and update functions for user.
  """

  alias Suxuri.HTTP

  defmodule Profile do
    defstruct [:url, :body, :header_url]

    @type t :: %__MODULE__{}

    @spec new(Map.t) :: t
    def new(%{"url" => url, "body" => body, "headerUrl" => header_url}) do
      %__MODULE__{url: url, body: body, header_url: header_url}
    end

    def new(_), do: nil
  end

  defstruct [:id, :name, :display_name, :avatar_url, :profile]

  @type t :: %__MODULE__{}

  @spec new(Map.t) :: t
  def new(user = %{"id" => id, "name" => name, "displayName" => display_name,
            "avatarUrl" => avatar_url}) do
    profile = Map.get(user, "profile")
    %__MODULE__{id: id, name: name, display_name: display_name,
                avatar_url: avatar_url, profile: Profile.new(profile)}
  end

  @doc """
  Get information of a user.

  ## Example

      iex> Suxuri.User.get 1
      %Suxuri.User{id: 1, name: "shikakun", ...}
  """
  @spec get(pos_integer) :: t
  def get(user_id) do
    HTTP.get!("/users/#{user_id}") |> new_user
  end

  @doc """
  Get information of authenticated user.

  ## Example

      iex> Suxuri.User.self
      %Suxuri.User{...}
  """
  @spec self :: t
  def self do
    HTTP.get!("/user") |> new_user
  end

  @doc """
  Update metadata of authenticated user.

  ## Example

      iex> Suxuri.User.update [
        display_name: "おれ",
        avatar_url: "http://example.com/my_face.png"
      ]
      %Suxuri.User{...}
  """
  @spec update(Keyword.t | Map.t) :: t
  def update(params) do
    HTTP.put!("/user", params) |> new_user
  end

  @doc """
  Update display name of authenticated user.

  ## Example

      iex> Suxuri.User.update_name "おれおれ"
      %Suxuri.User{...}
  """
  @spec update_name(String.t) :: t
  def update_name(name) when is_binary(name) do
    HTTP.put!("/user", %{"displayName" => name}) |> new_user
  end

  @doc """
  Update avatar URL of authenticated user.

  ## Example

      iex> Suxuri.User.update_avatar "http://example.com/my_face.png"
      %Suxuri.User{...}
  """
  @spec update_avatar(String.t) :: t
  def update_avatar(url) when is_binary(url) do
    HTTP.put!("/user", %{"avatarUrl" => url}) |> new_user
  end

  @doc false
  @spec new_user(Map.t) :: t
  defp new_user(%{"user" => user}), do: new(user)
end
