defmodule Suxuri.User do
  alias Suxuri.HTTP

  defmodule Profile do
    defstruct [:url, :body, :header_url]

    def new(%{"url" => url, "body" => body, "headerUrl" => header_url}) do
      %__MODULE__{url: url, body: body, header_url: header_url}
    end

    def new(_), do: nil
  end

  defstruct [:id, :name, :display_name, :avatar_url, :profile]

  def new(user = %{"id" => id, "name" => name, "displayName" => display_name,
            "avatarUrl" => avatar_url}) do
    profile = Map.get(user, "profile")
    %__MODULE__{id: id, name: name, display_name: display_name,
                avatar_url: avatar_url, profile: Profile.new(profile)}
  end

  def get(user_id) do
    HTTP.get!("/users/#{user_id}") |> new_user
  end

  def self do
    HTTP.get!("/user") |> new_user
  end

  def update(params) when is_map(params) do
    HTTP.put!("/user", params) |> new_user
  end

  def update_name(name) when is_binary(name) do
    HTTP.put!("/user", %{"displayName" => name}) |> new_user
  end

  def update_avatar(url) when is_binary(url) do
    HTTP.put!("/user", %{"avatarUrl" => url}) |> new_user
  end

  defp new_user(%{"user" => user}), do: new(user)
end
