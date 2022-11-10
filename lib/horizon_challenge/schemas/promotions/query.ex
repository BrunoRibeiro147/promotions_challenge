defmodule HorizonChallenge.Schemas.Promotions.Query do
  @moduledoc """
  Query module for Promotions
  """

  import Ecto.Query

  def by_list_of_promotions_codes(queryable, promotions_codes),
    do: where(queryable, [promotion: promotion], promotion.code in ^promotions_codes)
end
