defmodule BillWeb.BillControllerTest do
  use BillWeb.ConnCase
  doctest Bill

  alias Bill.Repo

  test "GET /bills/new", %{conn: conn} do
    conn = get(conn, "/bills/new")
    assert html_response(conn, 200) =~ "Load Csv File"
  end

  test "When csv upload is valid, should return a success message" do
    upload = %{"upload" => %Plug.Upload{path: "test/fixtures/bill_valid.csv", filename: "bill_valid.csv"}}
    conn = post(conn, "/upload_csv", %{:upload => upload})

    assert get_flash(conn, :info) =~ "All bills created successfully."

    bill_1 = Bill.Bill |> Ecto.Query.first |> Bill.Repo.one
    bill_2 = Bill.Bill |> Ecto.Query.last  |> Bill.Repo.one

    bill_1 = Bill.Repo.preload(bill_1, :item)
    bill_2 = Bill.Repo.preload(bill_2, :item)

    IO.inspect bill_1
    IO.inspect bill_2

    assert bill_1.number_bill        == "53190"
    assert bill_1.clients_first_name == "Daniel"
    assert bill_1.clients_last_name  == "Campos"
    assert bill_1.id_client          == "3"
    assert bill_1.item.code          == "3"
    assert bill_1.item.description   == "procesador A10"
    assert bill_1.item.quantity      == 2
    assert bill_1.item.price         == 1000000
    assert bill_1.item.discount_percentage == 10
    assert bill_1.item.total_price   == 800000

    assert bill_2.number_bill        == "53191"
    assert bill_2.clients_first_name == "Sebastian"
    assert bill_2.clients_last_name  == "Campos"
    assert bill_2.id_client          == "4"
    assert bill_2.item.code          == "4"
    assert bill_2.item.description   == "Hero Black 7"
    assert bill_2.item.quantity      == 1
    assert bill_2.item.price         == 1500000
    assert bill_2.item.discount_percentage == 20
    assert bill_2.item.total_price   == 1200000
  end

  test "When csv upload is empty, should return a error message with file name" do
    upload = %{"upload" => %Plug.Upload{path: "test/fixtures/bill_empty.csv", filename: "bill_empty.csv"}}
    conn = post(conn, "/upload_csv", %{:upload => upload})

    assert get_flash(conn, :error) =~ "The file bill_empty.csv is empty, plis check it."
  end

  test "When csv upload has a invalid headers, should return a error message with file name and error" do
    upload = %{"upload" => %Plug.Upload{path: "test/fixtures/bill_invalid_headers.csv", filename: "bill_invalid_headers.csv"}}
    conn = post(conn, "/upload_csv", %{:upload => upload})

    assert get_flash(conn, :error) =~ "The file bill_invalid_headers.csv has an error with headers, plis check it."
  end

  test "When csv upload has a invalid data in some bills, should return a error message with file name, lines with error and explain error" do
    upload = %{"upload" => %Plug.Upload{path: "test/fixtures/bill_invalid_data.csv", filename: "bill_invalid_data.csv"}}
    conn = post(conn, "/upload_csv", %{:upload => upload})

    assert get_flash(conn, :error) =~ "The file bill_invalid_data.csv has an error Row has length 8 - expected length 9 on line 2, plis check it."
  end
end
