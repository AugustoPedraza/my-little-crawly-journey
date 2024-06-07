defmodule CrawlyQuestWeb.WebsiteLive.Show do
  use CrawlyQuestWeb, :live_view

  alias CrawlyQuest.Crawler

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:website, Crawler.get_website!(id))}
  end

  defp page_title(:show), do: "Show Website"
  defp page_title(:edit), do: "Edit Website"
end
