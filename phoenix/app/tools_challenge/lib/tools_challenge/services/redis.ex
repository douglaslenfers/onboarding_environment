defmodule ToolsChallenge.Services.Redis do
  alias ToolsChallenge.Cache.RedisServer

  def set(key, value) do
    RedisServer.call_query(["SET", key, value])
  end

  def get(key) do
    RedisServer.call_query(["GET", key])
  end
end
