defmodule BillCreator do
  alias Bill.Bill

  defmodule BillStruct do
    defstruct [:number_bill, :clients_first_name, :clients_last_name, :id_client, :item_code, :item_description, :item_quantity]
  end

  def create_bill(path) do
    path
      |> File.stream!
      |> CSV.decode
      |> prepare_bill
  end

  def prepare_bill(bill_decode) do
    bill_decode
      |> get_values
      |> save_values
  end

  def get_values(bill_decode) do
    struct = %BillStruct{}
    bill_struct = List.delete(Map.keys(struct), :__struct__)
    case Enum.take(bill_decode, 1) do
      [ok: bill_struct] ->
        Enum.take(bill_decode, 100)
          |> Keyword.get_values(:ok)
          |> List.delete_at(0)
    end
  end

  def save_values(values) do
    Enum.map(values, &save_bill/1)
  end

  def save_bill(bill) do
    clean_bill = Enum.map(bill, &String.trim/1)
    data_bill = %BillStruct{
      number_bill:        Enum.at(clean_bill, 0),
      clients_first_name: Enum.at(clean_bill, 1),
      clients_last_name:  Enum.at(clean_bill, 2),
      id_client:          Enum.at(clean_bill, 3),
      item_code:          Enum.at(clean_bill, 4),
      item_description:   Enum.at(clean_bill, 5),
      item_quantity:      String.to_integer(Enum.at(clean_bill, 6))
    }
    Bill.create_bill(Map.from_struct(data_bill))
  end

  def has_error(error) do
    "Ocurred an error #{error}"
  end
end
