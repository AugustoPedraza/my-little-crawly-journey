defmodule CrawlyQuest.CrawlerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CrawlyQuest.Crawler` context.
  """

  import CrawlyQuest.AccountsFixtures

  def valid_website_attributes(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      name: "Some Website",
      url: "http://some.url",
    })
    |> add_user()
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

  defp add_user(%{user_id: _} = website_attrs), do: website_attrs
  defp add_user(website_attrs) do
    %{id: user_id} = user_fixture()

    Enum.into(website_attrs, %{user_id: user_id})
  end
end
