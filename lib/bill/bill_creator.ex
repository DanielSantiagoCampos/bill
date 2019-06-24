defmodule BillCreator do
  alias Bill.Item
  alias Bill.Bill

  defmodule BillStruct do
    defstruct [
      :number_bill,
      :clients_first_name,
      :clients_last_name,
      :id_client,
      :code,
      :description,
      :quantity,
      :price,
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
    IO.inspect(prepare_header(bill_decode, filename))
    prepare_header(bill_decode, filename)
  end

  def prepare_header(bill_decode, filename) do
    struct = %BillStruct{}
    bill_struct = List.delete(Map.keys(struct), :__struct__)
    validate_headers(bill_decode, Enum.take(bill_decode, 1), bill_struct, filename)
  end

  def validate_headers(bill_decode, header, correct_header, filename) do
    case header do
      [ok: _] ->
        [ok: prepare_header] = header
        ready_header = Enum.sort(Enum.map(Enum.map(prepare_header, &String.trim/1), &String.to_atom/1))
        ready_correct_header = Enum.sort(correct_header)
        valid_header(bill_decode, ready_header, ready_correct_header, filename)
      [] ->
        error_struct = %ErrorStruct{file_name: filename}
        has_error(:empty_file, error_struct)
    end
  end

  def valid_header(bill_decode, header, correct_header, filename) do
    case header == correct_header do
      true ->
        save_values_simple(bill_decode, filename)
      false ->
        error_struct = %ErrorStruct{file_name: filename}
        has_error(:incorrect_header, error_struct)
    end
  end

  def take_data(bill_decode) do
    Enum.take(bill_decode, 100)
      |> Keyword.get_values(:ok)
      |> List.delete_at(0)
  end

  def save_values_simple(bill_decode, filename) do
    case validate_values(bill_decode, filename) do
      [:ok] ->
        Keyword.get_values(Enum.take(bill_decode, 100), :ok)
          |> List.delete_at(0)
          |> save_values(filename)
      [] ->
        error_struct = %ErrorStruct{file_name: filename}
        has_error(:empty_file, error_struct)
      [error: error] ->
        [error: error]
    end
  end

  def validate_values(bill_decode, filename) do
    case Enum.count(Keyword.get_values(Enum.take(bill_decode, 100), :error)) >= 1 do
      false ->
        [:ok]
      true ->
        error_struct = %ErrorStruct{file_name: filename, explain_error: List.first(Keyword.get_values(Enum.take(bill_decode, 100), :error))}
        has_error(:invalid_lines, error_struct)
    end
  end

  def save_values(values, filename) do
    case Enum.uniq(Keyword.keys(Enum.map(values, &save_bill/1))) do
      [:ok] ->
        [ok: "All bills created successfully"]
      [error: error] ->
        [error: error]
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
      code:           Enum.at(clean_bill, 4),
      description:    Enum.at(clean_bill, 5),
      quantity:       String.to_integer(Enum.at(clean_bill, 6)),
      price:          String.to_integer(Enum.at(clean_bill, 7)),
      discount_percentage: String.to_integer(Enum.at(clean_bill, 8)),
    }

    {:ok, bill} = Bill.create_bill(Map.from_struct(data_bill))
    Item.create_item(Map.from_struct(data_item), bill)
  end

  def has_error(error_type, error_struct) do
    handle_error = fn
      :empty_file       -> "The file #{error_struct.file_name} is empty, plis check it."
      :incorrect_header -> "The file #{error_struct.file_name} has an error with headers, plis check it."
      :invalid_lines    -> "The file #{error_struct.file_name} has an error #{error_struct.explain_error}, plis check it."
      :global_error     -> "The file #{error_struct.file_name} has an error, plis check it."
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
