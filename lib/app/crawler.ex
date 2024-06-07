defmodule CrawlyQuest.Crawler do
  @moduledoc """
  The Crawler context.
  """

  import Ecto.Query, warn: false
  alias CrawlyQuest.Repo
  alias Ecto.Multi

  alias CrawlyQuest.Crawler.{Link, Website}

  @doc """
  Returns the list of crawler_websites.

  ## Examples

      iex> list_crawler_websites()
      [%Website{}, ...]

  """
  def list_crawler_websites(%{user_id: user_id}) do
    query = from w in Website, where: w.user_id == ^user_id

    Repo.all(query)
  end

  @doc """
  Gets a single website.

  Raises `Ecto.NoResultsError` if the Website does not exist.

  ## Examples

      iex> get_website!(123)
      %Website{}

      iex> get_website!(456)
      ** (Ecto.NoResultsError)

  """
  def get_website!(id), do: Repo.get!(Website, id)


  def get_website_with_links!(user_id, id) do
    query = from w in Website,
      where: w.user_id == ^user_id and w.id == ^id,
      preload: [:links]

    Repo.one!(query)
  end

  @doc """
  Creates a website.

  ## Examples

      iex> create_website(%{field: value})
      {:ok, %Website{}}

      iex> create_website(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_website(attrs \\ %{}) do
    %Website{}
    |> Website.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking website changes.

  ## Examples

      iex> change_website(website)
      %Ecto.Changeset{data: %Website{}}

  """
  def change_website(%Website{} = website, attrs \\ %{}) do
    Website.changeset(website, attrs)
  end

  def scrap_links(%Website{} = website) do
    case extract_links(website.url) do
      {:ok, found_links}        -> process_found_links(found_links, website)
      {:error, :page_not_found} -> mark_failed_website(website, "page not found")
      {:error, _}               -> mark_failed_website(website, "unknown error parsing url")
    end
  end

  defp process_found_links(found_links, website) do
    case save_website_and_links_trx(found_links, website) do
      {:ok, %{updated_website: updated_website}} ->
        {:ok, updated_website}

      {:error, failed_op, _failed_value, _changes_so_far} ->
        mark_failed_website(website, "Failed links scrapping saving(code:#{failed_op})")
      end
  end

  defp mark_failed_website(website, reason) do
    updated_website = website
                      |> Website.mark_as_done_changeset(%{status: "failed", total_links: 0})
                      |> Repo.update!()

    {:error, updated_website, reason}
  end

  defp save_website_and_links_trx(found_links, website) do
    found_links
    |> Enum.with_index()
    |> Enum.reduce(Multi.new(), fn {{url, content}, index}, multi ->
      if url && String.trim(content || "") != "" do
        attrs = %{url: url, content: content, website_id: website.id}
        changeset = Link.changeset(%Link{}, attrs)

        step_name = "insert_link_#{index}"
        Multi.insert(multi, step_name, changeset)
      else
        # skip url with nil
        multi
      end
    end)
    |> Multi.update(:updated_website, Website.mark_as_done_changeset(website, %{total_links: length(found_links), status: "completed"}))
    |> Repo.transaction()
  end

  defp extract_links(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        links = body
                |> Floki.find("a")
                |> Enum.map(fn element ->
                  href = Floki.attribute(element, "href") |> List.first()
                  {href, Floki.text(element)}
                end)

        {:ok, links}
      {:ok, %HTTPoison.Response{status_code: 404}} ->
        {:error, :page_not_found}
      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  @doc """
  Returns the list of crawler_links.

  ## Examples

      iex> list_crawler_links()
      [%Link{}, ...]

  """
  def list_crawler_links do
    Repo.all(Link)
  end

  @doc """
  Creates a link.

  ## Examples

      iex> create_link(%{field: value})
      {:ok, %Link{}}

      iex> create_link(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_link(attrs \\ %{}) do
    %Link{}
    |> Link.changeset(attrs)
    |> Repo.insert()
  end
end
