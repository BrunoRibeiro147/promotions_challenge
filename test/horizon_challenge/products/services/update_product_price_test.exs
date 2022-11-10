defmodule HorizonChallenge.Products.Services.UpdateProductPriceTest do
  use HorizonChallenge.DataCase, async: true

  alias HorizonChallenge.Products.Services.UpdateProductPrice
  alias HorizonChallenge.Schemas.Product

  describe "execute/1" do
    setup do
      %{id: product_id, price: old_price} = insert(:product)

      new_price = Money.new(2500)

      %{product_id: product_id, price: new_price, old_price: old_price}
    end

    test "should update the product price when the product exists", %{
      product_id: product_id,
      price: price,
      old_price: old_price
    } do
      %Product{price: new_price} = UpdateProductPrice.execute(product_id, price)

      assert new_price != old_price
    end

    test "returns an error if product does not exist", %{price: price} do
      assert {:error, :not_found} = UpdateProductPrice.execute(Enum.random(1..1000), price)
    end
  end
end
