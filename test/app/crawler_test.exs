defmodule CrawlyQuest.CrawlerTest do
  use CrawlyQuest.DataCase

  alias CrawlyQuest.Crawler

  import CrawlyQuest.CrawlerFixtures

  describe "create_website/1" do
    test "requires name and url to be set" do
      {:error, changeset} = Crawler.create_website(%{})

      assert %{
        name: ["can't be blank"],
        url: ["can't be blank"]
      } = errors_on(changeset)
    end

    test "validates url when given" do
      {:error, changeset} = Crawler.create_website(%{name: "Google url", url: "invailid google url"})

      assert %{
               url: ["must to start with http:// or https:// and no spaces"],
             } = errors_on(changeset)
    end

    test "creates a website" do
      {:ok, website} = Crawler.create_website(valid_website_attributes(url: "https://cool.com", name: "Cool website"))
      assert website.name == "Cool website"
      assert website.url == "https://cool.com"
    end
  end


    # alias CrawlyQuest.Crawler.Website

    # import CrawlyQuest.CrawlerFixtures


  # describe "crawler_websites" do
    # test "list_crawler_websites/0 returns all crawler_websites" do
    #   website = website_fixture()
    #   assert Crawler.list_crawler_websites() == [website]
    # end

    # test "get_website!/1 returns the website with given id" do
    #   website = website_fixture()
    #   assert Crawler.get_website!(website.id) == website
    # end

    # test "create_website/1 with valid data creates a website" do
    #   valid_attrs = %{name: "some name", url: "http://some.url"}

    #   assert {:ok, %Website{} = website} = Crawler.create_website(valid_attrs)
    #   assert website.name == "some name"
    #   assert website.url == "http://some.url"
    # end

    # test "create_website/1 with invalid data returns error changeset" do
    #   assert {:error, %Ecto.Changeset{}} = Crawler.create_website(@invalid_attrs)
    # end

    # test "update_website/2 with valid data updates the website" do
    #   website = website_fixture()
    #   update_attrs = %{name: "some updated name", url: "some updated url"}

    #   assert {:ok, %Website{} = website} = Crawler.update_website(website, update_attrs)
    #   assert website.name == "some updated name"
    #   assert website.url == "some updated url"
    # end

    # test "update_website/2 with invalid data returns error changeset" do
    #   website = website_fixture()
    #   assert {:error, %Ecto.Changeset{}} = Crawler.update_website(website, @invalid_attrs)
    #   assert website == Crawler.get_website!(website.id)
    # end

    # test "delete_website/1 deletes the website" do
    #   website = website_fixture()
    #   assert {:ok, %Website{}} = Crawler.delete_website(website)
    #   assert_raise Ecto.NoResultsError, fn -> Crawler.get_website!(website.id) end
    # end

    # test "change_website/1 returns a website changeset" do
    #   website = website_fixture()
    #   assert %Ecto.Changeset{} = Crawler.change_website(website)
    # end
  # end
end
