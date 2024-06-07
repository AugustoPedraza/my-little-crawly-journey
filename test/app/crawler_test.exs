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
end
