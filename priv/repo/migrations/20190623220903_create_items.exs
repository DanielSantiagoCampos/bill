defmodule Bill.Repo.Migrations.CreateItems do
  use Ecto.Migration

  def change do
    create table(:items) do
      add :code, :string
      add :description, :string
      add :quantity, :integer
      add :price, :integer
      add :discount_percentage, :integer
      add :total_price, :integer
    end
  end
end
