defmodule Bill.Repo do
  use Ecto.Repo,
    otp_app: :bill,
    adapter: Ecto.Adapters.Postgres
end
