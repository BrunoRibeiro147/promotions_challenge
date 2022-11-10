defmodule HorizonChallenge.Schemas.Promotions.Repository do
  @moduledoc """
  Repository module for Promotions
  """

  import Ecto.Query

  alias HorizonChallenge.Schemas.Promotion

  alias HorizonChallenge.Schemas.Promotions.Query

  @doc """
  Fetches all `promotions` by promotion codes
  """

  @spec list_promotions_by_code(promotions_codes :: list(String.t())) :: list(Promotion.t())
  def list_promotions_by_code(promotions_codes) do
    from(promotion in Promotion, as: :promotion, preload: [:products], select: promotion)
    |> Query.by_list_of_promotions_codes(promotions_codes)
    |> HorizonChallenge.Repo.all()
  end
end
