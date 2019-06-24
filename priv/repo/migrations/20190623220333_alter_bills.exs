defmodule Bill.Repo.Migrations.AlterBills do
  use Ecto.Migration

  def change do
    alter table(:bills) do
      remove :item_code
      remove :item_description
      remove :item_quantity
    end
  end
end
