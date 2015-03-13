# Suxuri

[suzuri](https://suzuri.jp) API client library for Elixir.

## Install

Add suxuri to `deps` and `application`.

```elixir
def application do
  [applications: [:logger, :suxuri]]
end

defp deps do
  [{:suxuri, github: "Joe-noh/suxuri"}]
end
```

[Access token](https://suzuri.jp/developer/apps) can be configured via `config.exs` or environment variable.

```elixir
config :suxuri, :access_token, "**************************************"
```

```bash
export SUXURI_ACCESS_TOKEN=**************************************
```

Confirm it works.

```elixir
iex(1)> Suxuri.User.self
%Suxuri.User{avatar_url: "https://dp3obxrw75ln8.cloudfront.net/users/avatars/1564.png?1396656294",
 display_name: "じょ", id: 1564, name: "Joe_noh",
 profile: %Suxuri.User.Profile{body: "ニヤニヤが止まらねぇなあ",
  header_url: nil, url: "https://twitter.com/Joe_noh"}}
```

## Contribution

Very welcomed. Especially testing.
