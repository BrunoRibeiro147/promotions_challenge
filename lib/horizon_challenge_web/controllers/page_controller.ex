defmodule HorizonChallengeWeb.PageController do
  use HorizonChallengeWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
