defmodule Tunez.Music.Album do
  @moduledoc """
  Represents an album in the music domain.
  """
  use Ash.Resource,
    otp_app: :ash_studio_demo,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tunez_albums"
    repo AshStudioDemo.Repo
  end

  resource do
    description "A collection of songs"
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:artist_id, :name, :year_released, :cover_image_url]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :year_released, :integer do
      allow_nil? false
    end

    attribute :cover_image_url, :string

    timestamps()
  end

  relationships do
    belongs_to :artist, Tunez.Music.Artist do
      allow_nil? false
    end

    has_many :tracks, Tunez.Music.Track
  end

  calculations do
    calculate :duration, :string, Tunez.Music.Calculations.SecondsToMinutes
  end

  aggregates do
    sum :duration_seconds, :tracks, :duration_seconds
  end

  identities do
    identity :unique_album_names_per_artist, [:name, :artist_id],
      message: "already exists for this artist"
  end
end
