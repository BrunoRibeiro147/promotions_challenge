defmodule HorizonChallenge.Repo.Migrations.CreatePromotionsTable do
  use Ecto.Migration

  def change do
    create table(:promotions) do
      add :name, :string
      add :code, :string
      add :amount_for_enable_promotion, :integer
      add :products_affected_by_promotion, :string
      add :discount_percentage, :integer

      timestamps(type: :utc_datetime)
    end
  end
end
