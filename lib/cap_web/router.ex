defmodule CapWeb.Router do
  use CapWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/", CapWeb do
    pipe_through :api

    post "/increment", CounterController, :increment
  end
end
