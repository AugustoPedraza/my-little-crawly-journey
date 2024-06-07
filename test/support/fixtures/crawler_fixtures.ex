defmodule CrawlyQuest.CrawlerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CrawlyQuest.Crawler` context.
  """

  @doc """
  Generate a website.
  """
  def website_fixture(attrs \\ %{}) do
    {:ok, website} =
      attrs
      |> Enum.into(%{
        name: "some name",
        url: "some url"
      })
      |> CrawlyQuest.Crawler.create_website()

    website
  end
end
