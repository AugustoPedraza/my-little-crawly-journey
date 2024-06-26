defmodule CrawlyQuestWeb.WebsiteLive.FormComponent do
  use CrawlyQuestWeb, :live_component

  alias CrawlyQuest.Crawler

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage website records in your database.</:subtitle>
      </.header>

      <.simple_form
        for={@form}
        id="website-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={@form[:name]} type="text" label="Name" />
        <.input field={@form[:url]} type="text" label="Url" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Website</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  # def mount(_params, _session,  socket) do
  # # def mount(_params, _session, %{assigns: %{current_user: current_user}} = socket) do
  #   IO.puts("???????????????????????????")
  #   # current_user |> IO.inspect(label: "current_user")
  #   socket.assigns |> IO.inspect(label: "socket.assigns")
  #   IO.puts("???????????????????????????")

  #   {:ok, socket}
  # end

  @impl true
  def update(%{website: website} = assigns, socket) do
    changeset = Crawler.change_website(website)

    {:ok,
     socket
     |> assign(assigns)
     |> assign_form(changeset)}
  end

  @impl true
  def handle_event("validate", %{"website" => website_params}, socket) do
    changeset =
      socket.assigns.website
      |> Map.put("user_id", socket.assigns.current_user.id)
      |> Crawler.change_website(website_params)
      |> Map.put(:action, :validate)

    {:noreply, assign_form(socket, changeset)}
  end

  def handle_event("save", %{"website" => website_params}, socket) do
    save_website(socket, socket.assigns.action, website_params)
  end

  defp save_website(socket, :new, params) do
    website_params = Map.put(params, "user_id", socket.assigns.current_user.id)

    case Crawler.create_website(website_params) do
      {:ok, website} ->
        notify_parent({:saved, website})

        {:noreply,
         socket
         |> put_flash(:info, "Website created successfully")
         |> push_patch(to: socket.assigns.patch)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign_form(socket, changeset)}
    end
  end

  defp assign_form(socket, %Ecto.Changeset{} = changeset) do
    assign(socket, :form, to_form(changeset))
  end

  defp notify_parent(msg), do: send(self(), {__MODULE__, msg})
end
