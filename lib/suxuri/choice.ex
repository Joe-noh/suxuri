defmodule Suxuri.Choice do
  alias Suxuri.HTTP
  alias Suxuri.User

  defstruct [:id, :title, :description, :secret, :banner_url, :products_count, :user]

  def new(%{"id" => id, "title" => title, "description" => description, "secret" => secret,
            "bannerUrl" => banner_url, "productsCount" => count, "user" => user}) do
    %__MODULE__{id: id, title: title, description: description, secret: secret,
                banner_url: banner_url, products_count: count, user: User.new(user)}
  end

  def get(choice_id) when is_integer(choice_id) do
    HTTP.get!("/choices/#{choice_id}") |> new_choice
  end

  defp new_choice(%{"choice" => choice}), do: new(choice)
end
