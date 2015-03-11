defmodule Suxuri.Item do
  alias Suxuri.HTTP

  def list do
    HTTP.get("/items")
  end
end
