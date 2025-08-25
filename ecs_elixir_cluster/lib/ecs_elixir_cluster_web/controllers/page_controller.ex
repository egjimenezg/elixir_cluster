defmodule EcsElixirClusterWeb.PageController do
  use EcsElixirClusterWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
