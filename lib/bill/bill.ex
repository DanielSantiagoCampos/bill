defmodule Bill.Bill do
  use Ecto.Schema

  schema "bills" do
    field :number_bill,        :string
    field :clients_first_name, :string
    field :clients_last_name,  :string
    field :id_client,          :string
    has_one :item, Bill.Item
  end

  def create_bill(params \\ %{}) do
    %Bill.Bill{}
      |> Bill.Bill.changeset(params)
      |> Bill.Repo.insert
  end

  def changeset(bill, params \\ %{}) do
    bill
      |> Ecto.Changeset.cast(params, [:number_bill, :clients_first_name, :clients_last_name, :id_client])
      |> Ecto.Changeset.validate_required([:number_bill, :clients_first_name, :clients_last_name, :id_client])
  end

end
