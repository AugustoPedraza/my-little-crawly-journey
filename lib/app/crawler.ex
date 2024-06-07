defmodule CrawlyQuest.Crawler do
  @moduledoc """
  The Crawler context.
  """

  import Ecto.Query, warn: false
  alias CrawlyQuest.Repo

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
     Enum.each(1..5, fn n ->
       Process.sleep(1_000)
       IO.puts("SENDING ASYNC TASK MESSAGE #{n}")
     end)

     %{website | total_links: 10, status: :completed}
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
