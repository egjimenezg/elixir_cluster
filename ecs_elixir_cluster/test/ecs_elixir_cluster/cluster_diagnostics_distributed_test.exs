defmodule EcsElixirCluster.ClusterDiagnosticsDistributedTest do
  use ExUnit.Case, async: false
  alias EcsElixirCluster.ClusterDiagnostics

  setup do
    cookie = Node.get_cookie()

    {:ok, peer_1, node_1} =
      :peer.start_link(%{name: :peer_1, cookie: cookie})

    {:ok, peer_2, node_2} =
      :peer.start_link(%{name: :peer_2, cookie: cookie})

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
end
