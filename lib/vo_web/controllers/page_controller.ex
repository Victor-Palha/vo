defmodule VoWeb.PageController do
  use VoWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
