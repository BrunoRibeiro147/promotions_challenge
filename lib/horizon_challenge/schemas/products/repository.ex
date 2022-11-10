defmodule HorizonChallenge.Schemas.Products.Repository do
  @moduledoc """
  Repository module for Products
  """

  import Ecto.Query

  alias HorizonChallenge.Schemas.Product
  alias HorizonChallenge.Schemas.Products.Query

  @doc """
  Fetches all `products` by products codes
  """

  @spec list_products_by_code(products_codes :: list(String.t())) :: list(Product.t())
  def list_products_by_code(products_codes) do
    from(product in Product, as: :product, select: product)
    |> Query.by_list_of_products_codes(products_codes)
    |> HorizonChallenge.Repo.all()
  end
end
