defmodule Tunez.Artists.FormLive do
  use AshStudioDemoWeb, :live_view

  import Tunez.MusicComponents

  require Logger

  @impl true
  def mount(%{"id" => id}, _uri, socket) do
    form =
      Tunez.Music.get_artist_by_id!(id)
      |> Tunez.Music.form_to_update_artist()

    {:ok, assign(socket, form: to_form(form), page_title: "Edit Artist")}
  end

  def mount(_params, _uri, socket) do
    form = Tunez.Music.form_to_create_artist()
    {:ok, assign(socket, form: to_form(form), page_title: "New Artist")}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <.h1>{@page_title}</.h1>
      </.header>
      <.simple_form
        :let={form}
        id="artist_form"
        as={:form}
        for={@form}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={form[:name]} label="Name" />
        <.input field={form[:biography]} type="textarea" label="Biography" />
        <:actions>
          <.button type="primary">Save</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def handle_event("validate", %{"form" => form_data}, socket) do
    socket =
      update(socket, :form, fn form ->
        AshPhoenix.Form.validate(form, form_data)
      end)

    {:noreply, socket}
  end

  def handle_event("save", %{"form" => form_data}, socket) do
    case AshPhoenix.Form.submit(socket.assigns.form, params: form_data) do
      {:ok, artist} ->
        socket =
          socket
          |> put_flash(:info, "Artist saved successfully")
          |> push_navigate(to: ~p"/artists/#{artist}")

        {:noreply, socket}

      {:error, form} ->
        socket =
          socket
          |> put_flash(:error, "Could not save artist data")
          |> assign(:form, form)

        {:noreply, socket}
    end
  end
end
