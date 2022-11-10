defmodule HorizonChallenge.Products.Services.CreateProduct do
  @moduledoc """
  Service to create a product
  """

  alias HorizonChallenge.Schemas.Product

  def execute(params) do
    params
    |> Product.changeset()
    |> HorizonChallenge.Repo.insert!()
  end
end
