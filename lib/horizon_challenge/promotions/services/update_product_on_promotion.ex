defmodule HorizonChallenge.Promotions.Services.UpdateProductOnPromotion do
  @moduledoc """
  Service to update the products on a promotion
  """

  alias HorizonChallenge.Schemas.Product
  alias HorizonChallenge.Schemas.Promotion

  def execute(promotion_id, product_id) do
    with {:ok, promotion} <- get_promotion(promotion_id),
         {:ok, product} <- get_product(product_id) do
      update_products_on_promotion(promotion, product)
    end
  end

  defp get_promotion(promotion_id) do
    case fetch_and_preload_promotion(promotion_id) do
      nil -> {:error, :promotion_not_found}
      promotion -> {:ok, promotion}
    end
  end

  defp fetch_and_preload_promotion(promotion_id) do
    Promotion
    |> HorizonChallenge.Repo.get(promotion_id)
    |> HorizonChallenge.Repo.preload(:products)
  end

  defp get_product(product_id) do
    case HorizonChallenge.Repo.get(Product, product_id) do
      nil -> {:error, :product_not_found}
      product -> {:ok, product}
    end
  end

  defp update_products_on_promotion(promotion, product) do
    promotion
    |> Promotion.upsert_promotion_products(product)
    |> HorizonChallenge.Repo.update!()
  end
end
