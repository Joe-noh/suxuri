defmodule Suxuri.Item do
  @moduledoc ~S"""
  Item is kind of products which is made in suzuri like t-shirt, mug and so on.
  """

  alias Suxuri.HTTP

  defmodule Variant do
    defmodule Color do
      defstruct [:id, :name, :rgb]

      @type t :: %__MODULE__{}

      @spec new(Map.t) :: t
      def new(%{"id" => id, "name" => name, "rgb" => rgb}) do
        %__MODULE__{id: id, name: name, rgb: rgb}
      end
    end

    defmodule Size do
      defstruct [:id, :name]

      @type t :: %__MODULE__{}

      @spec new(Map.t) :: t
      def new(%{"id" => id, "name" => name}) do
        %__MODULE__{id: id, name: name}
      end
    end

    defstruct [:id, :price, :exemplary, :color, :size, :enabled]

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

    defp from_list([head | rest], acc), do: from_list(rest, [new(head) | acc])
    defp from_list([], acc), do: Enum.reverse acc
  end

  defstruct [:id, :name, :angles, :humanize_name, :variants]

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
