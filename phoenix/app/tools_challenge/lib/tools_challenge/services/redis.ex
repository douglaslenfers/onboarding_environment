defmodule ToolsChallenge.Services.Redis do
  alias ToolsChallenge.Cache.RedisServer

  def set(key, value) do
    try do
      "OK" = RedisServer.call_query(["SET", key, value])
      :ok
    catch
      _ -> :error
    end
  end

  def get(key) do
    try do
      value = RedisServer.call_query(["GET", key])
      {:ok, value}
    catch
      _ -> {:error, :not_found}
    end
  end

  def del(key) do
    case RedisServer.call_query(["DEL", key]) do
      "1" -> :ok
      _ -> :error
    end
  end
end
