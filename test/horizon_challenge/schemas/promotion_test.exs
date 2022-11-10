defmodule HorizonChallenge.Schemas.PromotionTest do
  use HorizonChallenge.DataCase, async: true

  alias HorizonChallenge.Schemas.Promotion

  describe "changeset/2" do
    setup do
      params = %{
        name: "Buy 2 itens and gain 1 for free",
        code: "2-for-1",
        amount_for_enable_promotion: 2,
        discount_percentage: 100,
        products_affected_by_promotion: "1"
      }

      %{params: params}
    end

    test "returns an valid changeset if all params are valid", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = Promotion.changeset(params)
    end

    for field <- [
          :name,
          :code,
          :amount_for_enable_promotion,
          :discount_percentage,
          :products_affected_by_promotion
        ] do
      test "returns an invalid changeset if #{field} is missing", %{params: params} do
        assert %Ecto.Changeset{valid?: false} =
                 params
                 |> Map.drop([unquote(field)])
                 |> Promotion.changeset()
      end
    end
  end
end
