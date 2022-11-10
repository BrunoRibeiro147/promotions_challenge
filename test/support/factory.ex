defmodule HorizonChallenge.Factory do
  @moduledoc """
  HorizonChallenge applications factories (ExMachina)
  """

  use ExMachina.Ecto, repo: HorizonChallenge.Repo

  use HorizonChallenge.Factories.Promotion
  use HorizonChallenge.Factories.Product
  use HorizonChallenge.Factories.ProductPromotion
end
