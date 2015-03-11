defmodule Suxuri.User do
  alias Suxuri.HTTP

  def get(user_id) do
    HTTP.get("/users/#{user_id}")
  end

  def self do
    HTTP.get("/user")
  end

  def update(params) when is_map(params) do
    HTTP.put("/user", params)
  end

  def update_name(name) when is_binary(name) do
    HTTP.put("/user", %{"displayName" => name})
  end

  def update_avatar(url) when is_binary(url) do
    HTTP.put("/user", %{"avatarUrl" => url})
  end
end
