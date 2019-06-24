defmodule BillWeb.BillController do
  use BillWeb, :controller
  alias Bill.Repo
  alias Bill.Bill

  def new(conn, _params) do
    render conn, "new.html"
  end

  def create(conn, %{"upload" => upload}) do
    %{"upload" => plug} = upload
    case BillCreator.create_bill(plug) do
      [ok: message] ->
        conn
        |> put_flash(:info, message)
        |> redirect(to: Routes.bill_path(conn, :new))
      [error: error] ->
        conn
        |> put_flash(:info, error)
        |> redirect(to: Routes.bill_path(conn, :new))
    end
  end
end
