defmodule AshStudioDemoWeb.PageController do
  use AshStudioDemoWeb, :controller

  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    redirect(conn, to: "/studio")
    # render(conn, :home, layout: false)
  end
end
