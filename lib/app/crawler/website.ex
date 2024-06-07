defmodule CrawlyQuest.Crawler.Website do
  use Ecto.Schema
  import Ecto.Changeset

  alias CrawlyQuest.Accounts.User

  @status [:pending, :in_progress, :completed, :failed]

  schema "crawler_websites" do
    field :name, :string
    field :url, :string
    field :total_links, :integer
    field :status, :string

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(website, attrs) do
    website
    |> cast(attrs, [:name, :url, :user_id])
    |> validate_required([:name])
    |> put_change(:status, :pending)
    |> validate_subset(:status, @status)
    |> validate_url()
  end

  defp validate_url(changeset) do
    changeset
    |> validate_required([:url])
    |> validate_format(:url, ~r/^https?:\/\/[\S]+/, message: "must to start with http:// or https:// and no spaces")
    |> validate_length(:url, max: 160)
  end
end
