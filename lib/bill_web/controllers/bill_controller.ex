defmodule BillWeb.BillController do
  use BillWeb, :controller
  alias Bill.Repo
  alias Bill.Bill

  def new(conn, _params) do
    render conn, "new.html"
  end

  def csv(conn, %{"upload" => upload}) do
    IO.inspect("######################################")
    IO.inspect(upload.path)
    IO.inspect("######################################")
  end

  def create(conn, %{"upload" => upload}) do
 #  {:ok, csv} = Map.fetch(bill_params, "bill")
 #  {:ok, plug} = Map.fetch(csv, "csv")
 #  Map.to_list(plug)
 #  {:ok, path} = Map.fetch(plug, :path)
 #  path
 #    |> File.stream!
 #    |> CSV.decode
 #    |> Enum.take(1)
 #  BillConverter.convert_csv(path)
 #  IO.inspect(Map.fetch(plug, :path))
 #  IO.inspect("######################################")

 #  map = bill_params["bill"]["csv"]
 #  {:ok, path} = Map.fetch(map, :path)
 #  path
 #    |> BillConverter.convert_csv
  end
end
