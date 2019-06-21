defmodule Bill.Repo.Migrations.CreateBills do
  use Ecto.Migration

  def change do
    create table(:bills) do
      add :number_bill, :string
      add :clients_first_name, :string
      add :clients_last_name, :string
      add :id_client, :string
      add :item_code, :string
      add :item_description, :string
      add :item_quantity, :integer
    end
  end
end
