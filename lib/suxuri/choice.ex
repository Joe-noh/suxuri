defmodule Suxuri.Choice do
  @moduledoc ~S"""
  Choice is a collection of products. This module provides CRUD interface
  functions for choices and struct builder functions.
  """

  alias Suxuri.HTTP
  alias Suxuri.User

  defstruct [:id, :title, :description, :secret, :banner_url, :products_count, :user]

  def new(%{"id" => id, "title" => title, "description" => description, "secret" => secret,
            "bannerUrl" => banner_url, "productsCount" => count, "user" => user}) do
    %__MODULE__{id: id, title: title, description: description, secret: secret,
                banner_url: banner_url, products_count: count, user: User.new(user)}
  end

  def from_list(choices) when is_list(choices) do
    from_list(choices, [])
  end

  defp from_list([head | rest], acc), do: from_list(rest, [new(head) | acc])
  defp from_list([], acc), do: Enum.reverse acc

  def get(choice_id) when is_integer(choice_id) do
    HTTP.get!("/choices/#{choice_id}") |> new_choice
  end

  def list(params \\ []) do
    HTTP.get!("/choices", params) |> Map.get("choices") |> from_list
  end

  def create(title, params \\ []) do
    HTTP.post!("/choices", Keyword.merge([title: title], params))
    |> new_choice
  end

  def delete(choice_id) when is_integer(choice_id) do
    do_delete(choice_id)
  end
  def delete(%__MODULE__{} = choice) do
    do_delete(choice.id)
  end

  defp do_delete(choice_id) do
    HTTP.delete!("/choices/#{choice_id}")
  end

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

  def update(choice, params \\ [])
  def update(choice_id, params) when is_integer(choice_id) do
    do_update(choice_id, params)
  end
  def updpate(%__MODULE__{} = choice, params) do
    do_update(choice.id, params)
  end

  defp do_update(choice_id, params) do
    HTTP.put!("/choices/#{choice_id}", params) |> new_choice
  end

  defp new_choice(%{"choice" => choice}), do: new(choice)
end
