defmodule Suxuri.Item do
  @moduledoc ~S"""
  Item is kind of products which is made in suzuri like t-shirt, mug and so on.
  """

  alias Suxuri.HTTP

  defmodule Variant do
    defmodule Color do
      defstruct [
        id:   nil,
        name: "white",
        rgb:  nil
      ]

      @type t :: %__MODULE__{}

      @spec new(Map.t) :: t
      def new(%{"id" => id, "name" => name, "rgb" => rgb}) do
        %__MODULE__{id: id, name: name, rgb: rgb}
      end
    end

    defmodule Size do
      defstruct [
        id:   nil,
        name: "m"
      ]

      @type t :: %__MODULE__{}

      @spec new(Map.t) :: t
      def new(%{"id" => id, "name" => name}) do
        %__MODULE__{id: id, name: name}
      end
    end

    defstruct [
      id:        nil,
      price:     0,
      exemplary: false,
      color:     nil,
      size:      nil,
      enabled:   true
    ]

    @type t :: %__MODULE__{}

    @spec new(Map.t) :: t
    def new(%{"id" => id, "price" => price, "exemplary" => exemplary,
              "enabled" => enabled,  "color" => color, "size" => size}) do
      %__MODULE__{id: id, price: price, exemplary: exemplary, enabled: enabled,
                  color: Color.new(color), size: Size.new(size)}
    end

    @spec from_list([Map.t]) :: [t]
    def from_list(variants) when is_list(variants) do
      from_list(variants, [])
    end
    def from_list(_), do: []

    defp from_list([head | rest], acc), do: from_list(rest, [new(head) | acc])
    defp from_list([], acc), do: Enum.reverse acc
  end

  defstruct [
    id:            nil,
    name:          "",
    angles:        [],
    humanize_name: "",
    variants:      []
  ]

  @type t :: %__MODULE__{}

  @spec new(Map.t) :: t
  def new(item = %{"id" => id, "name" => name, "angles" => angles,
                   "humanizeName" => humanize_name}) do
    variants = Map.get(item, "variants")
    %__MODULE__{id: id, name: name, angles: angles, humanize_name: humanize_name,
                variants: Variant.from_list(variants)}
  end

  @spec from_list([Map.t]) :: [t]
  def from_list(items) when is_list(items) do
    from_list(items, [])
  end

  defp from_list([head | rest], acc), do: from_list(rest, [new(head) | acc])
  defp from_list([], acc), do: Enum.reverse acc

  @doc """
  Fetch and list all items

  ## Example

      iex> Suxuri.Item.list
      [%Suxuri.Item{...}, %Suxuri.Item{...}, ...]
  """
  @spec list :: [t]
  def list do
    HTTP.get!("/items") |> Map.get("items") |> from_list
  end
end

defimpl Inspect, for: Suxuri.Item.Variant.Color do
  def inspect(color, opts) do
    Suxuri.Inspector.inspect(color, [:name, :rgb], opts)
  end
end

defimpl Inspect, for: Suxuri.Item.Variant.Size do
  def inspect(size, opts) do
    Suxuri.Inspector.inspect(size, [:name], opts)
  end
end

defimpl Inspect, for: Suxuri.Item.Variant do
  def inspect(variant, opts) do
    Suxuri.Inspector.inspect(variant, [:id, :price, :color, :size], opts)
  end
end

defimpl Inspect, for: Suxuri.Item do
  def inspect(item, opts) do
    Suxuri.Inspector.inspect(item, [:id, :humanize_name], opts)
  end
end
