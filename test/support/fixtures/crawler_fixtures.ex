defmodule CrawlyQuest.CrawlerFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `CrawlyQuest.Crawler` context.
  """

  import CrawlyQuest.AccountsFixtures

  def valid_website_url, do: "http://some.url"

  def valid_website_attributes(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      name: "Some Website",
      url: valid_website_url(),
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

  @doc """
  Generate a link.
  """
  def link_fixture(attrs \\ %{}) do
    {:ok, link} =
      attrs
      |> valid_link_attributes()
      |> CrawlyQuest.Crawler.create_link()

    link
  end

  def valid_link_attributes(attrs \\ %{}) do
    attrs
    |> Enum.into(%{
      content: "some content",
      url: "https://inner.url"
    })
    |> add_website()
  end

  defp add_website(%{website_id: _} = link_attrs), do: link_attrs
  defp add_website(link_attrs) do
    %{id: website_id} = website_fixture()

    Enum.into(link_attrs, %{website_id: website_id})
  end
end
