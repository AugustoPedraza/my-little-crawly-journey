defmodule CrawlyQuest.Repo.Migrations.AddTotalLinksAndStatusToCrawlerWebsites do
  use Ecto.Migration

  def change do
    alter table(:crawler_websites) do
      add :status, :string
      add :total_links, :integer
    end
  end
end
