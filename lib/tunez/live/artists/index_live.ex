defmodule Tunez.Artists.IndexLive do
  use AshStudioDemoWeb, :live_view
  alias Tunez.Music

  require Logger

  import Tunez.MusicComponents

  def mount(_params, _session, socket) do
    artists =
      Music.read_artists!()

    socket =
      socket
      |> assign(:page_title, "Artists")
      |> assign(:artists, artists)

    {:ok, socket}
  end

  def render(assigns) do
    ~H"""
    <.header>
      <.h1>Artists</.h1>
      <.button_link navigate={~p"/artists/new"} kind="primary">
        New Artist
      </.button_link>
    </.header>

    <div :if={@artists == []} class="p-8 text-center">
      <.icon name="hero-face-frown" class="w-32 h-32 bg-gray-300" />
      <br /> No artist data to display!
    </div>

    <ul class="gap-6 lg:gap-12 grid grid-cols-2 sm:grid-cols-3 lg:grid-cols-4">
      <li :for={artist <- @artists}>
        <.artist_card artist={artist} />
      </li>
    </ul>
    """
  end

  def artist_card(assigns) do
    ~H"""
    <div id={"artist-#{@artist.id}"} data-role="artist-card" class="relative mb-2">
      <.link navigate={~p"/artists/#{@artist.id}"}>
        <.cover_image image={@artist.cover_image_url} />
      </.link>
    </div>
    <p>
      <.link
        navigate={~p"/artists/#{@artist.id}"}
        class="text-lg font-semibold"
        data-role="artist-name"
      >
        {@artist.name}
      </.link>
    </p>
    <.artist_card_album_info artist={@artist} />
    """
  end

  def artist_card_album_info(%{artist: %{album_count: 0}} = assigns), do: ~H""

  def artist_card_album_info(assigns) do
    ~H"""
    <span class="mt-2 text-sm leading-6 text-zinc-500">
      {@artist.album_count} {ngettext("album", "albums", @artist.album_count)},
      latest release {@artist.latest_album_year_released}
    </span>
    """
  end
end
