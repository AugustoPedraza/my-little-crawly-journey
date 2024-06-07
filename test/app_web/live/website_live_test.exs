defmodule CrawlyQuestWeb.WebsiteLiveTest do
  use CrawlyQuestWeb.ConnCase

  import Phoenix.LiveViewTest
  import CrawlyQuest.CrawlerFixtures

  @create_attrs %{name: "some name", url: "some url"}
  @update_attrs %{name: "some updated name", url: "some updated url"}
  @invalid_attrs %{name: nil, url: nil}

  defp create_website(_) do
    website = website_fixture()
    %{website: website}
  end

  describe "Index" do
    setup [:create_website, :register_and_log_in_user]

    test "lists all crawler_websites", %{conn: conn, website: website} do
      {:ok, _index_live, html} = live(conn, ~p"/crawler_websites")

      assert html =~ "Listing Crawler websites"
      assert html =~ website.name
    end

    test "saves new website", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/crawler_websites")

      assert index_live |> element("a", "New Website") |> render_click() =~
               "New Website"

      assert_patch(index_live, ~p"/crawler_websites/new")

      assert index_live
             |> form("#website-form", website: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#website-form", website: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/crawler_websites")

      html = render(index_live)
      assert html =~ "Website created successfully"
      assert html =~ "some name"
    end

    test "updates website in listing", %{conn: conn, website: website} do
      {:ok, index_live, _html} = live(conn, ~p"/crawler_websites")

      assert index_live |> element("#crawler_websites-#{website.id} a", "Edit") |> render_click() =~
               "Edit Website"

      assert_patch(index_live, ~p"/crawler_websites/#{website}/edit")

      assert index_live
             |> form("#website-form", website: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#website-form", website: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/crawler_websites")

      html = render(index_live)
      assert html =~ "Website updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes website in listing", %{conn: conn, website: website} do
      {:ok, index_live, _html} = live(conn, ~p"/crawler_websites")

      assert index_live |> element("#crawler_websites-#{website.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#crawler_websites-#{website.id}")
    end
  end

  describe "Show" do
    setup [:create_website, :register_and_log_in_user]

    test "displays website", %{conn: conn, website: website} do
      {:ok, _show_live, html} = live(conn, ~p"/crawler_websites/#{website}")

      assert html =~ "Show Website"
      assert html =~ website.name
    end

    test "updates website within modal", %{conn: conn, website: website} do
      {:ok, show_live, _html} = live(conn, ~p"/crawler_websites/#{website}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Website"

      assert_patch(show_live, ~p"/crawler_websites/#{website}/show/edit")

      assert show_live
             |> form("#website-form", website: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#website-form", website: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/crawler_websites/#{website}")

      html = render(show_live)
      assert html =~ "Website updated successfully"
      assert html =~ "some updated name"
    end
  end
end
