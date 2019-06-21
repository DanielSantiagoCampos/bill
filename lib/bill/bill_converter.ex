defmodule BillConverter do

  def convert_csv(path) do
    path
#     |> File.stream!
#     |> CSV.decode
#     |> Enum.take(1)
  end

  def get_columns do
    Enum.take(1)
  end
end
