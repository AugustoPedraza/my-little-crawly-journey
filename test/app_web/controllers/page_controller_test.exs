defmodule CrawlyQuestWeb.PageControllerTest do
  use CrawlyQuestWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Scrapes a page for information and generates a list of all the links found on that page."
  end
end
