defmodule Suxuri.Material do
  alias Suxuri.HTTP
  alias Suxuri.User
  alias Suxuri.Product
  alias Suxuri.Material

  defstruct [
    :id, :title, :description, :price, :texture_url, :violation, :published,
    :published_at, :uploaded_at, :dominant_rgb, :original_width, :original_height,
    :user
  ]

  def new(%{"id" => id, "title" => title, "description" => description,
            "price" => price, "textureUrl" => texture_url, "violation" => violation,
            "published" => published, "publishedAt" => published_at,
            "uploadedAt" => uploaded_at, "dominantRgb" => dominant_rgb,
            "originalWidth" => original_width, "originalHeight" => original_height,
            "user" => user}) do
    %__MODULE__{id: id, title: title, description: description, price: price,
                texture_url: texture_url, violation: violation, published: published,
                published_at: published_at, uploaded_at: uploaded_at,
                dominant_rgb: dominant_rgb, original_width: original_width,
                original_height: original_height, user: User.new(user)}
  end

  def create(title, texture, params \\ []) do
    base = [title: title, texture: texture]

    HTTP.post!("/materials", Keyword.merge(base, params))
    |> new_material_and_products
  end

  def update(material, params \\ [])
  def update(material_id, params) when is_integer(material_id) do
    do_update(material_id, params)
  end
  def update(%__MODULE__{} = material, params) do
    do_update(material.id, params)
  end

  defp do_update(material_id, params) do
    HTTP.put!("/materials/#{material_id}", params) |> new_material_and_products
  end

  def delete(material_id) when is_integer(material_id) do
    do_delete(material_id)
  end
  def delete(%__MODULE__{} = material) do
    do_delete(material.id)
  end

  defp do_delete(material_id) do
    HTTP.delete!("/materials/#{material_id}")
  end

  defp new_material_and_products(%{"material" => material, "products" => products}) do
    %{"material" => Material.new(material), "products" => Product.from_list(products)}
  end
end
