defmodule Bill.Repo.Migrations.AlterItems do
  use Ecto.Migration

  def change do
    alter table(:items) do
      add :bill_id, references(:bills)
    end
  end
end
