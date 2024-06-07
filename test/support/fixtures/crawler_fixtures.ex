defmodule CrawlyQuest.CrawlerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CrawlyQuest.Crawler` context.
  """

  import CrawlyQuest.AccountsFixtures

  def valid_website_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      name: "Some Website",
      url: "http://some.url",
      user: user_fixture()
    })
  end

  @doc """
  Generate a website.
  """
  def website_fixture(attrs \\ %{}) do
    {:ok, website} =
      attrs
      |> valid_website_attributes()
      |> CrawlyQuest.Crawler.create_website()

    website
  end
end
