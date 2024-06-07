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
    |> validate_required([:name])
    |> validate_url()
  end

  defp validate_url(changeset) do
    changeset
    |> validate_required([:url])
    |> validate_format(:url, ~r/^https?:\/\/[\S]+/, message: "must to start with http:// or https:// and no spaces")
    |> validate_length(:url, max: 160)
  end
end
