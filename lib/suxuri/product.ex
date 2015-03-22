defmodule Suxuri.Product do
  @moduledoc ~S"""
  Product is things you can buy at suzuri. This module provides GET functions,
  favorite function and struct builder functions.
  """

  alias Suxuri.HTTP
  alias Suxuri.Item
  alias Suxuri.Favorite
  alias Suxuri.Material

  defstruct [
    id:                  nil,
    title:               "",
    published:           true,
    published_at:        "",
    created_at:          "",
    updated_at:          "",
    examplary_angle:     nil,
    image_url:           "",
    sample_image_url:    "",
    url:                 "",
    sample_url:          "",
    resize_mode:         nil,
    item:                nil,
    material:            nil,
    item_variants:       [],
    sample_item_variant: nil
  ]

  @type t :: %__MODULE__{}

  @spec new(Map.t) :: t
  def new(product = %{"id" => id, "title" => title, "published" => published,
            "publishedAt" => published_at, "createdAt" => created_at,
            "updatedAt" => updated_at, "exemplaryAngle" => examplary_angle,
            "imageUrl" => image_url, "sampleImageUrl" => sample_image_url, "url" => url,
            "sampleUrl" => sample_url, "resizeMode" => resize_mode, "item" => item,
            "material" => material, "sampleItemVariant" => sample_item_variant}) do
    item_variants = Map.get(product, "itemVariants", [])
    %__MODULE__{id: id, title: title, published: published, published_at: published_at,
                created_at: created_at, updated_at: updated_at,
                examplary_angle: examplary_angle, image_url: image_url,
                sample_image_url: sample_image_url, url: url,
                sample_url: sample_url, resize_mode: resize_mode,
                item: Item.new(item), material: Material.new(material),
                item_variants: Item.Variant.from_list(item_variants),
                sample_item_variant: Item.Variant.new(sample_item_variant)}
  end

  @spec from_list([Map.t]) :: [t]
  def from_list(products) when is_list(products) do
    from_list(products, [])
  end

  defp from_list([head | rest], acc), do: from_list(rest, [new(head) | acc])
  defp from_list([], acc), do: Enum.reverse acc

  @doc """
  Find a product by id.

  ## Example

      iex> Suxuri.Product.get 10
      %Suxuri.Product{...}
  """
  @spec get(pos_integer) :: t
  def get(product_id) when is_integer(product_id) do
    HTTP.get!("/products/#{product_id}") |> new_product
  end

  @doc """
  Fetch products from suzuri.jp

  ## Options

  - `:limit`
  - `:offset`
  - `:user_id`
  - `:item_id`

  ## Example

      iex> Suxuri.Product.list
      [%Suxuri.Product{...}, %Suxuri.Product{...}, ...]

      iex> Suxuri.Product.list user_id: 1, limit: 2
      [%Suxuri.Product{...}, %Suxuri.Product{...}]
  """
  @spec list(Keyword.t) :: [t]
  def list(params \\ []) do
    HTTP.get!("/products", params) |> Map.get("products") |> from_list
  end

  @doc """
  Favorite a product

  ## Example

      iex> Suxuri.Product.favorite 10
      %Suxuri.Favorite{...}

      iex> Suxuri.Product.get(10) |> Suxuri.Product.favorite
      %Suxuri.Favorite{...}
  """
  @spec favorite(pos_integer | t) :: Favorite.t
  def favorite(product_id) when is_integer(product_id) do
    HTTP.post!("/products/#{product_id}/favorites", %{})
    |> Map.get("favorite")
    |> Favorite.new
  end

  def favorite(%__MODULE__{} = product) do
    favorite(product.id)
  end

  defp new_product(%{"product" => product}), do: new(product)
end

defimpl Inspect, for: Suxuri.Product do
  def inspect(product, opts) do
    Suxuri.Inspector.inspect(product, [:id, :title, :item, :material], opts)
  end
end
