defmodule Tunez.Music do
  @moduledoc """
  The music domain
  """
  use Ash.Domain,
    otp_app: :ash_studio_demo,
    extensions: [AshPhoenix]

  resources do
    resource Tunez.Music.Artist do
      define :create_artist, action: :create
      define :read_artists, action: :read
      define :get_artist_by_id, action: :read, get_by: :id
      define :update_artist, action: :update
      define :destroy_artist, action: :destroy
    end

    resource Tunez.Music.Album do
      define :create_album, action: :create
      define :get_album_by_id, action: :read, get_by: :id
      define :update_album, action: :update
      define :destroy_album, action: :destroy
    end

    resource Tunez.Music.Track
  end

  domain do
    description "The Tunez Music domain from the book"
  end
end
