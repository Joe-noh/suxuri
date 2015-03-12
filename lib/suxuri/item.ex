defmodule Suxuri.Item do
  alias Suxuri.HTTP

  defmodule Variant do
    defmodule Color do
      defstruct [:id, :name, :rgb]

      def new(%{"id" => id, "name" => name, "rgb" => rgb}) do
        %__MODULE__{id: id, name: name, rgb: rgb}
      end
    end

    defmodule Size do
      defstruct [:id, :name]

      def new(%{"id" => id, "name" => name}) do
        %__MODULE__{id: id, name: name}
      end
    end

    defstruct [:id, :price, :exemplary, :color, :size]

    def new(%{"id" => id, "price" => price, "exemplary" => exemplary,
              "color" => color, "size" => size}) do
      %__MODULE__{id: id, price: price, exemplary: exemplary,
                  color: Color.new(color), size: Size.new(size)}
    end

    def from_list(variants) when is_list(variants) do
      from_list(variants, [])
    end

    defp from_list([head | rest], acc), do: from_list(rest, [new(head) | acc])
    defp from_list([], acc), do: Enum.reverse acc
  end

  defstruct [:id, :name, :angles, :humanize_name, :variants]

  def new(%{"id" => id, "name" => name, "angles" => angles,
            "humanizeName" => humanize_name, "variants" => variants}) do
    %__MODULE__{id: id, name: name, angles: angles, humanize_name: humanize_name,
                variants: Variant.from_list(variants)}
  end

  def new(%{"id" => id, "name" => name, "angles" => angles,
            "humanizeName" => humanize_name}) do
    %__MODULE__{id: id, name: name, angles: angles, humanize_name: humanize_name}
  end

  def from_list(items) when is_list(items) do
    from_list(items, [])
  end

  defp from_list([head | rest], acc), do: from_list(rest, [new(head) | acc])
  defp from_list([], acc), do: Enum.reverse acc

  def list do
    HTTP.get!("/items") |> Map.get("items") |> from_list
  end
end
