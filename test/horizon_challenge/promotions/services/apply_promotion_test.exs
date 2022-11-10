defmodule HorizonChallenge.Promotions.Services.ApplyPromotionTest do
  use HorizonChallenge.DataCase, async: true

  alias HorizonChallenge.Promotions.Services.ApplyPromotion

  describe "execute/2" do
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

      params = [
        %{
          code: "VOUCHER",
          price: Money.new(500),
          final_price: Money.new(1500),
          promotion_applied: false,
          quantity: 3
        },
        %{
          code: "TSHIRT",
          price: Money.new(2000),
          final_price: Money.new(6000),
          promotion_applied: false,
          quantity: 3
        }
      ]

      %{params: params}
    end

    test "should apply promotion for all products", %{params: params} do
      pricing_rules = ["2-for-1", "discount-on-bulk"]

      response = ApplyPromotion.execute(params, pricing_rules)

      {:ok,
       [
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
         }
       ]} = response

      [product1, product2] = params
      {:ok, [response_product1, response_product2]} = response

      assert product1.final_price != response_product1.final_price
      assert product2.final_price != response_product2.final_price
    end

    test "should apply promotion for only one product", %{params: params} do
      pricing_rules = ["2-for-1"]

      response = ApplyPromotion.execute(params, pricing_rules)

      assert {:ok,
              [
                %{
                  code: "VOUCHER",
                  final_price: %Money{amount: 1000, currency: :EUR},
                  price: %Money{amount: 500, currency: :EUR},
                  promotion_applied: true,
                  quantity: 3
                },
                %{
                  code: "TSHIRT",
                  final_price: %Money{amount: 6000, currency: :EUR},
                  price: %Money{amount: 2000, currency: :EUR},
                  promotion_applied: false,
                  quantity: 3
                }
              ]} = response

      [product1, product2] = params
      {:ok, [response_product1, response_product2]} = response

      assert product1.final_price != response_product1.final_price
      assert product2.final_price == response_product2.final_price
    end

    test "should mantain products final price if promotion is not passed", %{params: params} do
      response = ApplyPromotion.execute(params, [])

      assert {:ok,
              [
                %{
                  code: "VOUCHER",
                  final_price: %Money{amount: 1500, currency: :EUR},
                  price: %Money{amount: 500, currency: :EUR},
                  promotion_applied: false,
                  quantity: 3
                },
                %{
                  code: "TSHIRT",
                  final_price: %Money{amount: 6000, currency: :EUR},
                  price: %Money{amount: 2000, currency: :EUR},
                  promotion_applied: false,
                  quantity: 3
                }
              ]} = response

      [product1, product2] = params
      {:ok, [response_product1, response_product2]} = response

      assert product1.final_price == response_product1.final_price
      assert product2.final_price == response_product2.final_price
    end

    test "should mantain products final price if promotion passed does not exist", %{
      params: params
    } do
      response = ApplyPromotion.execute(params, ["TEST"])

      assert {:ok,
              [
                %{
                  code: "VOUCHER",
                  final_price: %Money{amount: 1500, currency: :EUR},
                  price: %Money{amount: 500, currency: :EUR},
                  promotion_applied: false,
                  quantity: 3
                },
                %{
                  code: "TSHIRT",
                  final_price: %Money{amount: 6000, currency: :EUR},
                  price: %Money{amount: 2000, currency: :EUR},
                  promotion_applied: false,
                  quantity: 3
                }
              ]} = response

      [product1, product2] = params
      {:ok, [response_product1, response_product2]} = response

      assert product1.final_price == response_product1.final_price
      assert product2.final_price == response_product2.final_price
    end
  end
end
