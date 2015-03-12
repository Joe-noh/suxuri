defmodule Suxuri.Item do
  defmodule Variant do
    defmodule Color do
      defstruct [:id, :name, :rgb]
    end

    defmodule Size do
      defstruct [:id, :name]
    end

    defstruct [:id, :price, :exemplary, :color, :size]
  end

  defstruct [:id, :name, :angles, :humanize_name, :variants]

  alias Suxuri.HTTP

  def list do
    HTTP.get("/items")
  end
end
