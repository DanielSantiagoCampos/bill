defmodule BillCreator do
  alias Bill.Bill

  defmodule BillStruct do
    defstruct [
      :number_bill,
      :clients_first_name,
      :clients_last_name,
      :id_client,
      :item_code,
      :item_description,
      :item_quantity,
      :item_price,
      :discount_percentage
    ]
  end

  defmodule ErrorStruct do
    defstruct [
      :file_name,
      :line_error,
      :explain_error
    ]
  end

  def create_bill(plug) do
    plug.path
      |> File.stream!
      |> CSV.decode
      |> prepare_bill(plug.filename)
  end

  def prepare_bill(bill_decode, filename) do
    IO.inspect("##################################")
    IO.inspect(get_values(bill_decode))
    IO.inspect("##################################")
    case get_values(bill_decode) do
      [ok: bill_values] ->
        bill_values
          |> save_values(filename)
      [error: error] ->
        error_struct = %ErrorStruct{file_name: filename}
        has_error(error, error_struct)
    end
  end

  def get_values(bill_decode) do
    struct = %BillStruct{}
    bill_struct = List.delete(Map.keys(struct), :__struct__)
    validate_file(bill_decode, Enum.take(bill_decode, 1), bill_struct)
  end

  def validate_file(bill_decode, header, correct_header) do
    case header do
      [ok: correct_header] ->
        valid_header(bill_decode, header, correct_header)
      [] ->
        [error: :empty_file]
    end
  end

  def valid_header(bill_decode, header, correct_header) do
    [ok: header_to_compare] = header
    case header_to_compare == correct_header do
      true ->
        Enum.take(bill_decode, 100)
          |> Keyword.get_values(:ok)
          |> List.delete_at(0)
      false ->
        [error: :incorrect_header]
    end
  end

  def save_values(values, filename) do
    validate_bill(values, filename)
  end

  def validate_bill(values, filename) do
    values_length = Enum.map(values, &length/1)
    any_error = find_index(Enum.map(values_length, fn length_row -> length_row < 9 end), fn row_bad -> row_bad == true end)
    if length(any_error) == 0 do
      Enum.map(values, &save_bill/1)
    else
      error_struct = %ErrorStruct{file_name: filename, line_error: any_error}
      has_error(:error, :invalid_lines)
    end
  end

  def save_bill(bill) do
    clean_bill = Enum.map(bill, &String.trim/1)

    data_bill = %BillStruct{
      number_bill:        Enum.at(clean_bill, 0),
      clients_first_name: Enum.at(clean_bill, 1),
      clients_last_name:  Enum.at(clean_bill, 2),
      id_client:          Enum.at(clean_bill, 3),
    }

    data_item = %BillStruct{
      item_code:           Enum.at(clean_bill, 4),
      item_description:    Enum.at(clean_bill, 5),
      item_quantity:       String.to_integer(Enum.at(clean_bill, 6)),
      item_price:          String.to_integer(Enum.at(clean_bill, 7)),
      discount_percentage: String.to_integer(Enum.at(clean_bill, 8)),
    }

    Bill.create_bill(Map.from_struct(data_bill))
    Bill.create_item(Map.from_struct(data_item))
  end

  def has_error(error_type, error_struct) do
    handle_error = fn
      :empty_file       -> "The file #{error_struct.file_name}"
      :incorrect_header -> "The file #{error_struct.file_name} has an error with headers, plis check it."
      :invalid_lines    -> "The file #{error_struct.file_name} has an error in line/s #{error_struct.line_error}, plis check it."
    end
    [error: handle_error.(error_type)]
  end

  # find index
  def find_index(collection, function) do
    do_find_indexes(collection, function, 1, [])
  end

  def do_find_indexes([], _function, _counter, acc) do
    Enum.reverse(acc)
  end

  def do_find_indexes([h|t], function, counter, acc) do
    if function.(h) do
      do_find_indexes(t, function, counter + 1, [counter|acc])
    else
      do_find_indexes(t, function, counter + 1, acc)
    end
  end
end
