defmodule EcsElixirCluster.ClusterDiagnostics do
  def status do
    %{self: node(), connected_nodes: Node.list()}
  end
end
