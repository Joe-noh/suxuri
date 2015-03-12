defmodule Suxuri.Material do
  defstruct [
    :id, :title, :description, :price, :violation, :published,
    :published_at, :created_at, :updated_at, :dominant_rgb,
    :original_width, :original_height, :user
  ]
end
