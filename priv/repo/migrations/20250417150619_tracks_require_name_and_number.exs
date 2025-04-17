defmodule AshStudioDemo.Repo.Migrations.TracksRequireNameAndNumber do
  @moduledoc """
  Updates resources based on their most recent snapshots.

  This file was autogenerated with `mix ash_postgres.generate_migrations`
  """

  use Ecto.Migration

  def up do
    alter table(:tunez_tracks) do
      modify :number, :bigint, null: false
      modify :name, :text, null: false
    end
  end

  def down do
    alter table(:tunez_tracks) do
      modify :name, :text, null: true
      modify :number, :bigint, null: true
    end
  end
end
