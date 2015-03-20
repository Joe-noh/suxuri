defmodule Suxuri.Material do
  @moduledoc ~S"""
  Material is a thing needed for making a product. An image is required to
  create a material. This module includes functions for create, update and
  delete materials.
  """

  alias Suxuri.HTTP
  alias Suxuri.User
  alias Suxuri.Product
  alias Suxuri.Material

  defstruct [
    :id, :title, :description, :price, :texture_url, :violation, :published,
    :published_at, :uploaded_at, :dominant_rgb, :original_width, :original_height,
    :user
  ]

  @type t :: %__MODULE__{}

  @spec new(Map.t) :: t
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

  @doc """
  Create new material. Currently public images which have permalink are supported.

  ## Example

      iex> Suxuri.Material.create "しゃつ", "http://example.com/my_image.png", [
        products: [
          [item_id: 1,
           exemplary_item_variant_id: 151,
           published: true,
           resize_mode: :contain]
        ]
      ]
      %{
        "material" => %Suxuri.Material{...},
        "products" => [%Suxuri.Product{...}, %Suxuri.Product{...}, ...]
      }
  """
  @spec create(String.t, String.t, Keyword.t) :: t
  def create(title, texture, params \\ []) do
    base = [title: title, texture: texture]

    HTTP.post!("/materials", Keyword.merge(base, params))
    |> new_material_and_products
  end

  @doc """
  Create new material and a t-shirt from text.

  ## Example

      iex> Suxuri.Material.create_from_text "Yes, I'm an Ninja", [
        item_variant_id: 151
      ]
      %{
        "material" => %Suxuri.Material{...},
        "products" => [%Suxuri.Product{...}]
      }
  """
  @spec create_from_text(String.t, Keyword.t) :: t
  def create_from_text(text, params \\ []) do
    base = [text: text]

    HTTP.post!("/materials/text", Keyword.merge(base, params))
    |> new_material_and_products
  end

  @doc """
  Update a material and related products.

  ## Example

      iex> Suxuri.Material.update 180226, title: "しゃしゃしゃ"
  """
  @spec update(pos_integer | t, Keyword.t) :: t
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

  @doc """
  Delete a material and related products.

  ## Example

      iex> Suxuri.Material.delete 180226
  """
  @spec delete(pos_integer | t) :: :ok
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
