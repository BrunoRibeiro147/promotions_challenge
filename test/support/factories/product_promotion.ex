defmodule HorizonChallenge.Factories.ProductPromotion do
  @moduledoc false

  use ExMachina.Ecto, repo: Core.Repo

  alias HorizonChallenge.Schemas.ProductPromotion

  defmacro __using__(_opts) do
    quote do
      def product_promotion_factory do
        %ProductPromotion{
          product_id: Enum.random(1..1000),
          promotion_id: Enum.random(1..1000)
        }
      end
    end
  end
end
