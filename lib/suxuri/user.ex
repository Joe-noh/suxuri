defmodule Suxuri.User do
  alias Suxuri.HTTP

  defmodule Profile do
    defstruct [:url, :body, :header_url]
  end

  defstruct [:id, :name, :display_name, :avatar_url, :profile]

  def get(user_id) do
    HTTP.get("/users/#{user_id}") |> make_user
  end

  def self do
    HTTP.get("/user") |> make_user
  end

  def update(params) when is_map(params) do
    HTTP.put("/user", params) |> make_user
  end

  def update_name(name) when is_binary(name) do
    HTTP.put("/user", %{"displayName" => name}) |> make_user
  end

  def update_avatar(url) when is_binary(url) do
    HTTP.put("/user", %{"avatarUrl" => url}) |> make_user
  end

  defp new(%{"user" => %{"id" => id, "name" => name, "displayName" => display_name,
                         "avatarUrl" => avatar_url, "profile" => profile}}) do
    %__MODULE__{id: id, name: name, display_name: display_name,
                avatar_url: avatar_url, profile: new_profile(profile)}
  end

  defp new_profile(%{"url" => url, "body" => body, "headerUrl" => header_url}) do
    %__MODULE__.Profile{url: url, body: body, header_url: header_url}
  end

  defp make_user(tuple) do
    case tuple do
      {:ok, user} -> {:ok, new(user)}
      error -> error
    end
  end
end
