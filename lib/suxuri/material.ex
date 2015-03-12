defmodule Suxuri.Material do
  alias Suxuri.User

  defstruct [
    :id, :title, :description, :price, :texture_url, :violation, :published,
    :published_at, :created_at, :uploaded_at, :dominant_rgb, :original_width,
    :original_height, :user
  ]

  def new(%{"id" => id, "title" => title, "description" => description,
            "price" => price, "textureUrl" => texture_url, "violation" => violation,
            "published" => published, "publishedAt" => published_at,
            "uploadedAt" => uploaded_at,
            "dominantRgb" => dominant_rgb, "originalWidth" => original_width,
            "originalHeight" => original_height, "user" => user}) do
    %__MODULE__{id: id, title: title, description: description, price: price,
                texture_url: texture_url, violation: violation, published: published,
                published_at: published_at, uploaded_at: uploaded_at,
                dominant_rgb: dominant_rgb, original_width: original_width,
                original_height: original_height, user: User.new(user)}
  end
end
