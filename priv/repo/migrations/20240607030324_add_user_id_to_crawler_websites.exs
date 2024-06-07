defmodule CrawlyQuest.Repo.Migrations.AddUserIdToCrawlerWebsites do
  use Ecto.Migration

  def change do
    alter table(:crawler_websites) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
    end

    create index(:crawler_websites, [:user_id])
  end
end
