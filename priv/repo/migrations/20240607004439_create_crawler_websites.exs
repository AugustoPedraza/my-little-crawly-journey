defmodule CrawlyQuest.Repo.Migrations.CreateCrawlerWebsites do
  use Ecto.Migration

  def change do
    create table(:crawler_websites) do
      add :name, :string
      add :url, :string

      timestamps(type: :utc_datetime)
    end
  end
end
