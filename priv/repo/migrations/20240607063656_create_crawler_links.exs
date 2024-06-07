defmodule CrawlyQuest.Repo.Migrations.CreateCrawlerLinks do
  use Ecto.Migration

  def change do
    create table(:crawler_links) do
      add :url, :string
      add :content, :string
      add :website_id, references(:crawler_websites, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:crawler_links, [:website_id])
  end
end
