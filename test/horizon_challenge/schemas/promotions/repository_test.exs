defmodule HorizonChallenge.Schemas.Promotions.RepositoryTest do
  use HorizonChallenge.DataCase, async: true

  alias HorizonChallenge.Schemas.Promotions.Repository
  alias HorizonChallenge.Schemas.Promotion

  describe "list_promotions_by_code" do
    setup do
      insert(:promotion)

      insert(:promotion, %{code: "TEST"})

      :ok
    end

    test "should return a list of promotion when code exist" do
      assert [%Promotion{code: "2-for-1"}] = Repository.list_promotions_by_code(["2-for-1"])
    end

    test "should return an empty list if code does not exist" do
      assert [] = Repository.list_promotions_by_code(["BLABLA"])
    end
  end
end
