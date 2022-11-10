defmodule HorizonChallenge.Promotions.Services.UpdateProductsOnPromotionTest do
  use HorizonChallenge.DataCase, async: true

  alias HorizonChallenge.Promotions.Services.UpdateProductOnPromotion

  alias HorizonChallenge.Schemas.Promotion
  alias HorizonChallenge.Schemas.Product

  describe "execute/2" do
    setup do
      %{id: promotion_id} = insert(:promotion)
      %{id: product_id} = insert(:product)

      %{product_id: product_id, promotion_id: promotion_id}
    end

    test "should update the products on promotion if all params are valid", %{
      product_id: product_id,
      promotion_id: promotion_id
    } do
      assert %Promotion{
               id: ^promotion_id,
               products: [%Product{id: ^product_id}]
             } = UpdateProductOnPromotion.execute(promotion_id, product_id)
    end

    test "returns an error if promotion does not exist", %{product_id: product_id} do
      assert {:error, :promotion_not_found} =
               UpdateProductOnPromotion.execute(Enum.random(1..10000), product_id)
    end

    test "returns an error if product does not exist", %{promotion_id: promotion_id} do
      assert {:error, :product_not_found} =
               UpdateProductOnPromotion.execute(promotion_id, Enum.random(1..10000))
    end
  end
end
