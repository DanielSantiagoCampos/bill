defmodule BillWeb.BillController do
  use BillWeb, :controller
  alias Bill.Repo
  alias Bill.Bill

  def new(conn, _params) do
    changeset = Bill.change_bill(%Bill{})
    render conn, "new.html", changeset: changeset
  end
end
