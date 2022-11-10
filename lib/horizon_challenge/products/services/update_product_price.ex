defmodule HorizonChallenge.Products.Services.UpdateProductPrice do
  @moduledoc """
  Service to update the price of a product
  """

  alias HorizonChallenge.Schemas.Product

  def execute(product_id, price) do
    case HorizonChallenge.Repo.get(Product, product_id) do
      nil -> {:error, :not_found}
      product -> update_product_price(product, price)
    end
  end

  def update_product_price(product, price) do
    product
    |> Product.changeset(%{price: price})
    |> HorizonChallenge.Repo.update!()
  end
end
