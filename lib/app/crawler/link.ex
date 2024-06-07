defmodule CrawlyQuest.Crawler.Link do
  use Ecto.Schema
  import Ecto.Changeset

  alias CrawlyQuest.Crawler.Website

  schema "crawler_links" do
    field :url, :string
    field :content, :string

    belongs_to :website, Website

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(link, attrs) do
    link
    |> cast(attrs, [:url, :content])
    |> validate_required([:url, :content])
  end
end
