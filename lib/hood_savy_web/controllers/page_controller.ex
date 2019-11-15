defmodule HoodSavyWeb.PageController do
  use HoodSavyWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
