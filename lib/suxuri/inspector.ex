defmodule Suxuri.Inspector do
  import Inspect.Algebra

  def inspect(struct, count_key, body_keys, opts) do
    name  = name_of(struct)
    count = Map.get(struct, count_key, 0)

    do_inspect("#{name}(#{count})", take(struct, body_keys), opts)
  end

  def inspect(struct, body_keys, opts) do
    do_inspect(name_of(struct), take(struct, body_keys), opts)
  end

  defp do_inspect(title, body_keyword, opts) do
    surround_many("##{title}<", body_keyword, ">", opts, &to_s/2)
  end

  defp name_of(%{__struct__: atom_name}) do
    "Elixir." <> str_name = Atom.to_string(atom_name)
    str_name
  end

  defp take(struct, keys), do: do_take(struct, keys, [])

  defp do_take(_struct, [], acc), do: Enum.reverse acc
  defp do_take(struct, [key | keys], acc) do
    do_take(struct, keys, [{key, Map.get(struct, key)} | acc])
  end

  defp to_s({key, val}, _opts), do: "#{key}: #{inspect val}"
end
