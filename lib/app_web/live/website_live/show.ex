defmodule CrawlyQuestWeb.WebsiteLive.Show do
  use CrawlyQuestWeb, :live_view

  alias CrawlyQuest.Crawler

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    website = Crawler.get_website_with_links!(socket.assigns.current_user.id, id)

    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:website, website)}
  end

  defp page_title(:show), do: "Website Details"
end
