defmodule Bill.Bill do
  use Ecto.Schema
  alias Bill.Repo
  alias Bill.Bill

  schema "bills" do
    field :number_bill,        :string
    field :clients_first_name, :string
    field :clients_last_name,  :string
    field :id_client,          :string
    field :item_code,          :string
    field :item_description,   :string
    field :item_quantity,      :integer
  end

  def create_bill(params \\ %{}) do
    %Bill{}
      |> Bill.changeset(params)
      |> Repo.insert
  end

  def changeset(bill, params \\ %{}) do
    bill
      |> Ecto.Changeset.cast(params, [:number_bill, :clients_first_name, :clients_last_name, :id_client, :item_code, :item_description, :item_quantity])
      |> Ecto.Changeset.validate_required([:number_bill, :clients_first_name, :clients_last_name, :id_client, :item_code, :item_quantity])
  end

end
