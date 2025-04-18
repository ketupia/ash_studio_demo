defmodule Tunez.Music.Track do
  @moduledoc """
  Represents a track of an album in the music domain.
  """

  use Ash.Resource,
    otp_app: :ash_studio_demo,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tunez_tracks"
    repo AshStudioDemo.Repo
  end

  resource do
    description "A track on an album"
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:album_id, :name, :duration_seconds, :number]
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string, allow_nil?: false
    attribute :duration_seconds, :integer
    attribute :number, :integer, allow_nil?: false

    timestamps()
  end

  relationships do
    belongs_to :album, Tunez.Music.Album do
      allow_nil? false
    end
  end

  calculations do
    calculate :duration, :string, Tunez.Music.Calculations.SecondsToMinutes do
      public? true
    end
  end
end
