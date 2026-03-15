defmodule EcsElixirCluster.ClusterDiagnosticsDistributedTest do
  use ExUnit.Case, async: false
  alias EcsElixirCluster.ClusterDiagnostics

  defp peer_cookie_arg() do
    Node.get_cookie()
    |> Atom.to_string()
    |> String.to_charlist()
  end

  setup do
    :ok = ensure_distributed_node!()
    cookie = peer_cookie_arg()
    unique_id = System.unique_integer([:positive])

    {:ok, peer_1, node_1} =
      :peer.start_link(%{
        name: "peer_1_#{unique_id}",
        args: [~c"-setcookie", cookie]
      })

    {:ok, peer_2, node_2} =
      :peer.start_link(%{
        name: "peer_2_#{unique_id}",
        args: [~c"-setcookie", cookie]
      })

    on_exit(fn ->
      for peer <- [peer_1, peer_2] do
        try do
          :peer.stop(peer)
        catch
          :exit, _ -> :ok
        end
      end
    end)

    {:ok, node_1: node_1, node_2: node_2}
  end

  test "status includes connected cluster nodes", %{node_1: node_1, node_2: node_2} do
    assert Node.connect(node_1)
    assert Node.connect(node_2)

    status = ClusterDiagnostics.status()
    connected = MapSet.new(status.connected_nodes)

    assert MapSet.subset?(MapSet.new([node_1, node_2]), connected)
  end

  defp ensure_distributed_node! do
    if Node.alive?() do
      :ok
    else
      case :net_kernel.start([:cluster_test, :shortnames]) do
        {:ok, _pid} -> :ok
        {:error, {:already_started, _pid}} -> :ok
        {:error, reason} -> raise "could not start distributed node: #{inspect(reason)}"
      end
    end
  end
end
