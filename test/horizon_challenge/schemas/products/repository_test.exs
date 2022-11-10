defmodule HorizonChallenge.Schemas.Products.RepositoryTest do
  use HorizonChallenge.DataCase, async: true

  alias HorizonChallenge.Schemas.Products.Repository
  alias HorizonChallenge.Schemas.Product

  describe "list_promotions_by_code" do
    setup do
      insert(:product)
      insert(:product, %{code: "TEST"})
      :ok
    end

    test "should return a list of product when code exist" do
      assert [%Product{code: "TSHIRT"}] = Repository.list_products_by_code(["TSHIRT"])
    end

    test "should return an empty list if code does not exist" do
      assert [] = Repository.list_products_by_code(["BLABLA"])
    end
  end
end
