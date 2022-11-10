defmodule HorizonChallenge.Promotions.Services.CreatePromotionTest do
  use HorizonChallenge.DataCase, async: true

  alias HorizonChallenge.Promotions.Services.CreatePromotion
  alias HorizonChallenge.Schemas.Promotion

  describe "execute/1" do
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

    test "should create a promotion in the database", %{params: params} do
      assert %Promotion{id: promotion_id} = CreatePromotion.execute(params)

      assert %Promotion{} = HorizonChallenge.Repo.get(Promotion, promotion_id)
    end
  end
end
