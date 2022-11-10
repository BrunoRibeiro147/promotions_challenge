defmodule HorizonChallenge.Promotions.Services.CreatePromotion do
  @moduledoc """
  Service to create a product
  """

  alias HorizonChallenge.Schemas.Promotion

  def execute(params) do
    params
    |> Promotion.changeset()
    |> HorizonChallenge.Repo.insert!()
  end
end
