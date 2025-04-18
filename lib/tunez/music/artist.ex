defmodule Tunez.Music.Artist do
  @moduledoc """
  Represents an artist in the music domain.
  """

  use Ash.Resource,
    otp_app: :ash_studio_demo,
    domain: Tunez.Music,
    data_layer: AshPostgres.DataLayer

  postgres do
    table "tunez_artists"
    repo AshStudioDemo.Repo
  end

  resource do
    description "A band or performer"
  end

  actions do
    defaults [:create, :read, :update, :destroy]
    default_accept [:name, :biography]
  end

  preparations do
    prepare build(
              load: [
                :album_count,
                :cover_image_url,
                :latest_album_year_released
              ]
            )
  end

  attributes do
    uuid_primary_key :id

    attribute :name, :string do
      allow_nil? false
    end

    attribute :biography, :string do
    end

    timestamps()
  end

  relationships do
    has_many :albums, Tunez.Music.Album
  end

  aggregates do
    count :album_count, :albums do
      public? true
    end

    first :latest_album_year_released, :albums, :year_released do
      public? true
    end

    first :cover_image_url, :albums, :cover_image_url
  end
end
