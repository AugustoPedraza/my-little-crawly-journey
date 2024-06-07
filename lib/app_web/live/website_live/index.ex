defmodule CrawlyQuestWeb.WebsiteLive.Index do
  use CrawlyQuestWeb, :live_view

  alias CrawlyQuest.Crawler
  alias CrawlyQuest.Crawler.Website

  @impl true
  def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
    websites = Crawler.list_crawler_websites(%{user_id: current_user.id})

    {:ok, stream(socket, :crawler_websites, websites)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Website")
    |> assign(:website, %Website{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Crawler websites")
    |> assign(:website, nil)
  end

  @impl true
  def handle_info({CrawlyQuestWeb.WebsiteLive.FormComponent, {:saved, website}}, socket) do
    Task.async(fn ->
      Crawler.scrap_links(website)
    end)

    {:noreply, stream_insert(socket, :crawler_websites, website)}
  end

  def handle_info({ref, website} = _task_info, socket) do
    Process.demonitor(ref, [:flush])

    {:noreply, stream_insert(socket, :crawler_websites, website)}
  end
end
