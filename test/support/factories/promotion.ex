defmodule HorizonChallenge.Factories.Promotion do
  @moduledoc false

  use ExMachina.Ecto, repo: Core.Repo

  alias HorizonChallenge.Schemas.Promotion

  defmacro __using__(_opts) do
    quote do
      def promotion_factory do
        %Promotion{
          name: "Buy 2 itens and gain 1 for free",
          code: "2-for-1",
          amount_for_enable_promotion: 2,
          discount_percentage: 100,
          products_affected_by_promotion: "1"
        }
      end
    end
  end
end
