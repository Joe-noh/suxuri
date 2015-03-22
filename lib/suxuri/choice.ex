defmodule Suxuri.Choice do
  @moduledoc ~S"""
  Choice is a collection of products. This module provides CRUD interface
  functions for choices and struct builder functions.
  """

  alias Suxuri.HTTP
  alias Suxuri.User

  defstruct [
    id:             nil,
    title:          "",
    description:    "",
    secret:         false,
    banner_url:     "",
    products_count: 0,
    user:           nil
  ]

  @type t :: %__MODULE__{id: pos_integer}

  @spec new(Map.t) :: t
  def new(%{"id" => id, "title" => title, "description" => description, "secret" => secret,
            "bannerUrl" => banner_url, "productsCount" => count, "user" => user}) do
    %__MODULE__{id: id, title: title, description: description, secret: secret,
                banner_url: banner_url, products_count: count, user: User.new(user)}
  end

  @spec from_list([Map.t]) :: [t]
  def from_list(choices) when is_list(choices) do
    from_list(choices, [])
  end

  @doc false
  defp from_list([head | rest], acc), do: from_list(rest, [new(head) | acc])
  defp from_list([], acc), do: Enum.reverse acc

  @doc """
  Fetch a choice from suzuri.jp.

  ## Example

      iex> Suxuri.Choice.get(19)
      %Suxuri.Choice{banner_url: "...", description: "...", ...}
  """
  @spec get(pos_integer) :: t
  def get(choice_id) when is_integer(choice_id) do
    HTTP.get!("/choices/#{choice_id}") |> new_choice
  end

  @doc """
  Fetch choices. You can specify `limit` and `offset`.

  ## Example

      iex> Suxuri.Choice.list
      [%Suxuri.Choice{}, %Suxuri.Choice{}, ...]  # limit is 20. offset is 0

      iex> Suxuri.Choice.list limit: 10, offset: 100
      [%Suxuri.Choice{}, %Suxuri.Choice{}, ...]  # The list size is 10
  """
  @spec list(Keyword.t) :: [t]
  def list(params \\ []) do
    HTTP.get!("/choices", params) |> Map.get("choices") |> from_list
  end

  @doc """
  Issue a request to create new choice.

  ## Example

      iex> Suxuri.Choice.create "にゃー！", description: "わがはいの思い出"
      %Suxuri.Choice{description: "わがはいの思い出", title: "にゃー！", ...}

      iex> Suxuri.Choice.create "一気にたくさん", choice_products: [
        [product_id: 12, item_variant_id: 1],
        [product_id: 10, item_variant_id: 81]
      ]
      %Suxuri.Choice{title: "一気にたくさん", products_count: 2, ...}
  """
  @spec create(String.t, Keyword.t) :: t
  def create(title, params \\ []) do
    HTTP.post!("/choices", Keyword.merge([title: title], params))
    |> new_choice
  end

  @doc """
  Delete a choice.

  ## Example

      iex> Suxuri.Choice.delete 1149

      iex> Suxuri.Choice.get(1149) |> Suxuri.Choice.delete
  """
  @spec delete(pos_integer | t) :: :ok
  def delete(choice_id) when is_integer(choice_id) do
    do_delete(choice_id)
  end
  def delete(%__MODULE__{} = choice) do
    do_delete(choice.id)
  end

  @spec do_delete(pos_integer) :: :ok
  defp do_delete(choice_id) do
    HTTP.delete!("/choices/#{choice_id}")
  end

  @doc """
  Add an item to a choice.

  ## Example

      iex> Suxuri.Choice.add 1149, [product_id: 12, item_variant_id: 2]
      %Suxuri.Choice{...}
  """
  @spec add(pos_integer | t, Keyword.t) :: t
  def add(choice, params \\ [])
  def add(choice_id, params) when is_integer(choice_id) do
    do_add(choice_id, params)
  end
  def add(%__MODULE__{} = choice, params) do
    do_add(choice.id, params)
  end

  defp do_add(choice_id, params) do
    HTTP.post!("/choices/#{choice_id}", params) |> new_choice
  end

  @doc """
  Remove an item from a choice.

  ## Example

      iex> Suxuri.Choice.remove 1149, [product_id: 12, item_variant_id: 2]
      %Suxuri.Choice{...}
  """
  @spec remove(pos_integer | t, Keyword.t) :: t
  def remove(choice, params \\ [])
  def remove(choice_id, params) when is_integer(choice_id) do
    do_remove(choice_id, params)
  end
  def remove(%__MODULE__{} = choice, params) do
    do_remove(choice.id, params)
  end

  defp do_remove(choice_id, params) do
    HTTP.post!("/choices/#{choice_id}/remove", params) |> new_choice
  end

  @doc """
  Update a choice

  ## Example

      iex> Suxuri.Choice.update 1149, [title: "えいやー！"]
      %Suxuri.Choice{title: "えいやー！", ...}
  """
  @spec update(pos_integer | t, Keyword.t) :: t
  def update(choice, params \\ [])
  def update(choice_id, params) when is_integer(choice_id) do
    do_update(choice_id, params)
  end
  def update(%__MODULE__{} = choice, params) do
    do_update(choice.id, params)
  end

  defp do_update(choice_id, params) do
    HTTP.put!("/choices/#{choice_id}", params) |> new_choice
  end

  defp new_choice(%{"choice" => choice}), do: new(choice)
end

defimpl Inspect, for: Suxuri.Choice do
  alias Suxuri.Inspector

  def inspect(choice, opts) do
    Inspector.inspect(choice, :products_count, [:id, :title, :description, :user], opts)
  end
end
