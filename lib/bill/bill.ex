defmodule Bill.Bill do
  use Ecto.Schema
# alias Bill.Repo
# alias Bill.Bill
# alias Bill.Item

  schema "bills" do
    field :number_bill,        :string
    field :clients_first_name, :string
    field :clients_last_name,  :string
    field :id_client,          :string
    has_one :item, Bill.Item
  end

  def create_bill(params \\ %{}) do
    case Bill.Bill.changeset(%Bill.Bill{}, params) do
      {:ok, bill} ->
        bill
          |> Bill.Repo.insert
      {:error, changeset} ->
        {:error, changeset}
    end
  end

  def changeset(bill, params \\ %{}) do
    bill
      |> Ecto.Changeset.cast(params, [:number_bill, :clients_first_name, :clients_last_name, :id_client])
      |> Ecto.Changeset.validate_required([:number_bill, :clients_first_name, :clients_last_name, :id_client])
  end

end
