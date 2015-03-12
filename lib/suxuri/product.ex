defmodule Suxuri.Product do
  alias Suxuri.HTTP
  alias Suxuri.Item
  alias Suxuri.Material

  defstruct [
    :id, :title, :published, :published_at, :created_at, :updated_at,
    :examplary_angle, :image_url, :sample_image_url, :url, :sample_url,
    :resize_mode, :item, :material, :item_variants, :sample_item_variant
  ]

  def new(%{"id" => id, "title" => title, "published" => published,
            "publishedAt" => published_at, "createdAt" => created_at,
            "updatedAt" => updated_at, "exemplaryAngle" => examplary_angle,
            "imageUrl" => image_url, "sampleImageUrl" => sample_image_url,
            "url" => url, "sampleUrl" => sample_url, "resizeMode" => resize_mode,
            "item" => item, "material" => material, "itemVariants" => item_variants,
            "sampleItemVariant" => sample_item_variant}) do
    %__MODULE__{id: id, title: title, published: published, published_at: published_at,
                created_at: created_at, updated_at: updated_at,
                examplary_angle: examplary_angle, image_url: image_url,
                sample_image_url: sample_image_url, url: url, sample_url: sample_url,
                item: Item.new(item), material: Material.new(material),
                item_variants: Item.Variant.from_list(item_variants),
                sample_item_variant: Item.Variant.new(sample_item_variant)}
  end

  def get(product_id) when is_integer(product_id) do
    HTTP.get!("/products/#{product_id}") |> new_product
  end

  defp new_product(%{"product" => product}), do: new(product)
end
