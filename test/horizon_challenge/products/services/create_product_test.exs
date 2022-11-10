defmodule HorizonChallenge.Products.Services.CreateProductTest do
  use HorizonChallenge.DataCase, async: true

  alias HorizonChallenge.Products.Services.CreateProduct
  alias HorizonChallenge.Schemas.Product

  describe "execute/1" do
    setup do
      params = %{
        name: "T-Shirt",
        code: "TSHIRT",
        price: Money.new(1500)
      }

      %{params: params}
    end

    test "should create a product in the database", %{params: params} do
      assert %Product{id: product_id} = CreateProduct.execute(params)

      assert %Product{} = HorizonChallenge.Repo.get(Product, product_id)
    end
  end
end
