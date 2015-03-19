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
    :id, :title, :published, :published_at, :created_at, :updated_at,
    :examplary_angle, :image_url, :sample_image_url, :url, :sample_url,
    :resize_mode, :item, :material, :item_variants, :sample_item_variant
  ]

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

  def from_list(products) when is_list(products) do
    from_list(products, [])
  end

  defp from_list([head | rest], acc), do: from_list(rest, [new(head) | acc])
  defp from_list([], acc), do: Enum.reverse acc

  def get(product_id) when is_integer(product_id) do
    HTTP.get!("/products/#{product_id}") |> new_product
  end

  def list(params \\ []) do
    HTTP.get!("/products", params) |> Map.get("products") |> from_list
  end

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
