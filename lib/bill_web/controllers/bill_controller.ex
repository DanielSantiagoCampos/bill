defmodule BillWeb.BillController do
  use BillWeb, :controller
  alias Bill.Repo
  alias Bill.Bill

  def new(conn, _params) do
    render conn, "new.html"
  end

  def csv(conn, %{"upload" => upload}) do
    %{"upload" => plug} = upload
    case BillCreator.create_bill(plug.path) do
      [ok: bill] ->
        conn
        |> put_flash(:info, "Bill created success")
        |> redirect(to: Routes.bill_path(conn, :new))
    end
  end

  def create(conn, %{"upload" => upload}) do
  end
end
