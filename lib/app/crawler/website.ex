defmodule CrawlyQuest.Crawler.Website do
  use Ecto.Schema
  import Ecto.Changeset

  alias CrawlyQuest.Accounts.User
  alias CrawlyQuest.Crawler.Link

  @status ["pending", "in_progress", "completed", "failed"]

  schema "crawler_websites" do
    field :name, :string
    field :url, :string
    field :total_links, :integer
    field :status, :string

    has_many :links, Link

    belongs_to :user, User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(website, attrs) do
    website
    |> cast(attrs, [:name, :url, :user_id])
    |> validate_required([:name])
    |> put_change(:status, "pending")
    |> validate_inclusion(:status, @status)
    |> validate_url()
  end

  def mark_as_done_changeset(website, attrs) do
    website
    |> cast(attrs, [:total_links, :status])
    |> validate_required([:total_links])
    |> validate_inclusion(:status, @status)
  end

  defp validate_url(changeset) do
    changeset
    |> validate_required([:url])
    |> validate_format(:url, ~r/^https?:\/\/[\S]+/, message: "must to start with http:// or https:// and no spaces")
    |> validate_length(:url, max: 160)
  end
end
