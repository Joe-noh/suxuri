defmodule Suxuri.RateLimit do
  defstruct [:limit, :remaining, :reset_time]
end
