defmodule Bill.Item do
  use Ecto.Schema
# alias Bill.Repo
# alias Bill.Item

  schema "items" do
    field :code, :string
    field :description, :string
    field :quantity, :integer
    field :price, :integer
    field :discount_percentage, :integer
    field :total_price, :integer
    belongs_to :bill, Bill.Bill
  end

  def create_item(params \\ %{}, bill) do
    with_total = %{total_price: calculate_total_price(params[:price], params[:discount_percentage], params[:quantity])}
    attrs = Map.merge(params, with_total)

    item = Ecto.build_assoc(bill, :item, attrs)
    Bill.Repo.insert(item)
  end

  def calculate_total_price(price, percentage, quantity) do
    round((price - (((price * percentage) / 100) * quantity)))
  end
end
