defmodule HorizonChallenge.Schemas.Products.Query do
  @moduledoc """
  Query module for Promotions
  """

  import Ecto.Query

  def by_list_of_products_codes(queryable, products_codes),
    do: where(queryable, [product: product], product.code in ^products_codes)
end
