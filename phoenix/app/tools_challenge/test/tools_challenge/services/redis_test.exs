defmodule ToolsChallenge.Services.RedisTest do
  use ToolsChallenge.DataCase

  import Mock

  alias ToolsChallenge.Services.Redis

  setup_all do
    %{
      head: "valid_head",
      key: "valid_key",
      value: "valid_value",
      invalid_key: "invalid_key"
    }
  end

  describe "set redis" do
    test "on cache if valid params", %{key: key, value: value} do
      with_mock Exredis,
        query: fn
          _head, ["SET", _key, _value] -> "OK"
        end do
        assert Redis.set(key, value) == :ok
      end
    end
  end

  describe "get redis" do
    test "value when valid params", %{key: key, value: value} do
      with_mock Exredis,
        query: fn
          _head, ["GET", _key] -> value
        end do
        assert Redis.get(key) == {:ok, value}
      end
    end

    test "returns error when invalid params", %{invalid_key: invalid_key} do
      with_mock Exredis,
        query: fn
          _head, ["GET", _invalid_key] -> :not_found
        end do
        assert Redis.get(invalid_key) == {:ok, :not_found}
      end
    end
  end

  describe "del redis" do
    test "when valid params", %{key: key} do
      with_mock Exredis,
        query: fn
          _head, ["DEL", _key] -> "1"
        end do
        assert Redis.del(key) == :ok
      end
    end

    test "returns error when invalid params", %{invalid_key: invalid_key} do
      with_mock Exredis,
        query: fn
          _head, ["DEL", _key] -> "0"
        end do
        assert Redis.del(invalid_key) == :error
      end
    end
  end
end
