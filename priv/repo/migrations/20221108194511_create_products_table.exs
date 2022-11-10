defmodule HorizonChallenge.Repo.Migrations.CreateProductsTable do
  use Ecto.Migration

  def change do
    create table(:products) do
      add :code, :string
      add :name, :string
      add :price, :integer

      timestamps(type: :utc_datetime)
    end

    create unique_index(:products, [:code])
  end
end
