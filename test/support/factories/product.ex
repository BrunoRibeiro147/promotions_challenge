defmodule HorizonChallenge.Factories.Product do
  @moduledoc false

  use ExMachina.Ecto, repo: Core.Repo

  alias HorizonChallenge.Schemas.Product

  defmacro __using__(_opts) do
    quote do
      def product_factory do
        %Product{
          name: "T-Shirt",
          code: "TSHIRT",
          price: Money.new(2000)
        }
      end
    end
  end
end
