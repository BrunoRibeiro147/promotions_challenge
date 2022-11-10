defmodule HorizonChallenge.Repo.Migrations.CreateProductsPromotionsTable do
  use Ecto.Migration

  def change do
    create table(:products_promotions, primary_key: false) do
      add :promotion_id, references(:promotions, on_delete: :delete_all)
      add :product_id, references(:products, on_delete: :delete_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:products_promotions, [:promotion_id, :product_id],
             name: :product_id_promotion_id_unique_index
           )
  end
end
