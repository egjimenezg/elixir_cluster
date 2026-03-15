defmodule EcsElixirClusterWeb.ClusterController do
  use EcsElixirClusterWeb, :controller

  def status(conn, _params) do
    json(conn, EcsElixirCluster.ClusterDiagnostics.status())
  end
end
