defmodule BillWeb.Router do
  use BillWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", BillWeb do
    pipe_through :browser

    get "/", PageController, :index
    resources "/bills", BillController
    post "/upload_csv", BillController, :csv
  end

  # Other scopes may use custom stacks.
  # scope "/api", BillWeb do
  #   pipe_through :api
  # end
end
