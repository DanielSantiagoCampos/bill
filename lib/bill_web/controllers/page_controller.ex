defmodule BillWeb.PageController do
  use BillWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
