defmodule CrawlyQuest.Crawler.Website do
  use Ecto.Schema
  import Ecto.Changeset

  schema "crawler_websites" do
    field :name, :string
    field :url, :string

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(website, attrs) do
    website
    |> cast(attrs, [:name, :url])
    |> validate_required([:name, :url])
  end
end
