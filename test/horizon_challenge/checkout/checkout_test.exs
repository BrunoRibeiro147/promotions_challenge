defmodule HorizonChallenge.Checkout.CheckoutTest do
  use HorizonChallenge.DataCase, async: true

  describe "interface test" do
    setup do
      %{id: product_id_1} = insert(:product)

      %{id: product_id_2} =
        insert(:product, %{code: "VOUCHER", name: "Voucher", price: Money.new(500)})

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

      :ok
    end

    test "should be able to scan products and calculate total" do
      co = HorizonChallenge.Checkout.new(["2-for-1", "discount-on-bulk"])

      co.scan("TSHIRT")
      co.scan("TSHIRT")
      co.scan("TSHIRT")
      co.scan("VOUCHER")
      co.scan("TSHIRT")

      price = co.total()

      assert "€81,00" = price
    end
  end
end
