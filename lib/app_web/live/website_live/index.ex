defmodule CrawlyQuestWeb.WebsiteLive.Index do
  use CrawlyQuestWeb, :live_view

  alias CrawlyQuest.Crawler
  alias CrawlyQuest.Crawler.Website

  @impl true
  def mount(_params, _session, socket) do
    {:ok, stream(socket, :crawler_websites, Crawler.list_crawler_websites())}
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
    {:noreply, stream_insert(socket, :crawler_websites, website)}
  end
end
