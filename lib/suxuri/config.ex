defmodule Suxuri.Config do
  @moduledoc ~S"""
  This module provides an abstraction layer for configuration.
  """

  def access_token do
    get_conf(:access_token, "SUXURI_ACCESS_TOKEN")
  end

  defp get_conf(key, default_var_env_key \\ "") do
    Application.get_env(:suxuri, key, System.get_env(default_var_env_key))
  end
end
