defmodule HorizonChallenge.Checkout.Services.CalculateTotalTest do
  use HorizonChallenge.DataCase, async: true

  alias HorizonChallenge.Checkout.Services.CalculateTotal

  describe "execute/2" do
    setup do
      %{id: product_id_1} = insert(:product)

      %{id: product_id_2} =
        insert(:product, %{code: "VOUCHER", name: "Voucher", price: Money.new(500)})

      insert(:product, %{code: "MUG", name: "Coffee Mug", price: Money.new(750)})

      %{id: promotion_id_1} =
        insert(:promotion, %{
          name: "Buy 3 itens and gain discounts",
          code: "discount-on-bulk",
          amount_for_enable_promotion: 3,
          discount_percentage: 5,
          products_affected_by_promotion: "all"
        })

      %{id: promotion_id_2} = insert(:promotion)

      insert(:product_promotion, %{product_id: product_id_1, promotion_id: promotion_id_1})
      insert(:product_promotion, %{product_id: product_id_2, promotion_id: promotion_id_2})

      params = ["VOUCHER", "TSHIRT", "VOUCHER", "VOUCHER", "MUG", "TSHIRT", "TSHIRT", "TEST"]

      pricing_rules = ["2-for-1", "discount-on-bulk"]

      %{params: params, pricing_rules: pricing_rules}
    end

    test "should return the products with promotions applied and the total", %{
      params: params,
      pricing_rules: pricing_rules
    } do
      response = CalculateTotal.execute(params, pricing_rules)

      assert {
               :ok,
               %{
                 products: [
                   %{
                     code: "VOUCHER",
                     final_price: %Money{amount: 1000, currency: :EUR},
                     price: %Money{amount: 500, currency: :EUR},
                     promotion_applied: true,
                     quantity: 3
                   },
                   %{
                     code: "TSHIRT",
                     final_price: %Money{amount: 5700, currency: :EUR},
                     price: %Money{amount: 2000, currency: :EUR},
                     promotion_applied: true,
                     quantity: 3
                   },
                   %{
                     code: "MUG",
                     final_price: %Money{amount: 750, currency: :EUR},
                     price: %Money{amount: 750, currency: :EUR},
                     promotion_applied: false,
                     quantity: 1
                   }
                 ],
                 total: "€74,50"
               }
             } = response
    end

    test "returns an error in case all products are invalid", %{pricing_rules: pricing_rules} do
      assert {:error, :invalid_products} = CalculateTotal.execute(["TEST"], pricing_rules)
    end
  end
end
