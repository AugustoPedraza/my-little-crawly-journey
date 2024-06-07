defmodule CrawlyQuestWeb.WebsiteLiveTest do
  use CrawlyQuestWeb.ConnCase

  import Phoenix.LiveViewTest
  import CrawlyQuest.CrawlerFixtures

  # @create_attrs %{name: "some name", url: "some url"}
  # @update_attrs %{name: "some updated name", url: "some updated url"}
  # @invalid_attrs %{name: nil, url: nil}

  defp create_website(_) do
    website = website_fixture()
    %{website: website}
  end

  defp create_website_for_current_user(%{user: user}) do
    website = website_fixture(user_id: user.id, name: "website for current user", url: "https://logged.in")
    %{website_current_user: website}
  end

  describe "Index page on not logged in" do
    setup [:create_website]

    test "redirects", %{conn: conn} do
      result = conn
               |> live( ~p"/crawler_websites")
               |> follow_redirect(conn, "/users/log_in")

      assert {:ok, conn} = result
      assert Phoenix.Flash.get(conn.assigns.flash, :error) == "You must log in to access this page."
    end
  end

  describe "Index page on logged in" do
    setup [
      :create_website,
      :register_and_log_in_user,
      :create_website_for_current_user
    ]

    test "lists all crawler_websites of current user", %{conn: conn, website: another_website, website_current_user: website} do
      {:ok, _index_live, html} = live(conn, ~p"/crawler_websites")

      assert html =~ "Listing Crawler websites"
      assert html =~ website.name
      refute html =~ another_website.name
    end

    test "renders create button", %{conn: conn} do
      {:ok, _index_live, html} = live(conn, ~p"/crawler_websites")

      assert html =~ "New Website"
    end
  end

  describe "Create form" do
    setup [:register_and_log_in_user]

    setup do
      %{url: "https://google.wow"}
    end

    test "saves new website", %{conn: conn, url: url} do
      {:ok, index_live, _html} = live(conn, ~p"/crawler_websites")

      assert index_live |> element("a", "New Website") |> render_click() =~
               "New Website"

      assert_patch(index_live, ~p"/crawler_websites/new")

      index_live
      |> form("#website-form", %{
        "website" => %{"name" => "Cool Website", "url" => url}
      })
      |> render_submit()

      assert_patch(index_live, ~p"/crawler_websites")

      html = render(index_live)
      assert html =~ "Website created successfully"
      assert html =~ "https://google.wow"
    end
  end
end
