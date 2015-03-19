defmodule Suxuri.Choice do
  @moduledoc ~S"""
  Choice is a collection of products. This module provides CRUD interface
  functions for choices and struct builder functions.
  """

  alias Suxuri.HTTP
  alias Suxuri.User

  defstruct [:id, :title, :description, :secret, :banner_url, :products_count, :user]

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

  defp from_list([head | rest], acc), do: from_list(rest, [new(head) | acc])
  defp from_list([], acc), do: Enum.reverse acc

  @spec get(pos_integer) :: t
  def get(choice_id) when is_integer(choice_id) do
    HTTP.get!("/choices/#{choice_id}") |> new_choice
  end

  @spec list(Keyword.t) :: [t]
  def list(params \\ []) do
    HTTP.get!("/choices", params) |> Map.get("choices") |> from_list
  end

  @spec create(String.t, Keyword.t) :: t
  def create(title, params \\ []) do
    HTTP.post!("/choices", Keyword.merge([title: title], params))
    |> new_choice
  end

  @spec delete(pos_integer | t) :: %{}
  def delete(choice_id) when is_integer(choice_id) do
    do_delete(choice_id)
  end
  def delete(%__MODULE__{} = choice) do
    do_delete(choice.id)
  end

  @spec do_delete(pos_integer) :: %{}
  defp do_delete(choice_id) do
    HTTP.delete!("/choices/#{choice_id}")
  end

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
