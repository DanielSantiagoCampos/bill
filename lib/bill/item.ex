defmodule Bill.Item do
  use Ecto.Schema
  alias Bill.Repo
  alias Bill.Item

  schema "items" do
    field :code, :string
    field :description, :string
    field :quantity, :integer
    field :price, :integer
    field :discount_percentage, :integer
    field :total_price, :integer
    belongs_to :bill, Bill.Bill
  end

  def create_item(params \\ %{}) do
    %Item{}
      |> Item.changeset(params)
      |> Repo.insert
  end

  def changeset(item, params \\ %{}) do
    item
      |> Ecto.Changeset.cast(params, [:code, :description, :quantity, :price, :discount_percentage, :total_price])
      |> Ecto.Changeset.validate_required([:code, :description, :quantity, :price, :total_price])
  end

end
