defmodule HorizonChallenge.Schemas.ProductPromotionTest do
  use HorizonChallenge.DataCase, async: true

  alias HorizonChallenge.Schemas.ProductPromotion

  describe "changeset/2" do
    setup do
      params = %{
        product_id: Enum.random(1..1000),
        promotion_id: Enum.random(1..1000)
      }

      %{params: params}
    end

    test "returns an valid changeset if all params are valid", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = ProductPromotion.changeset(params)
    end

    for field <- [:product_id, :promotion_id] do
      test "returns an invalid changeset if #{field} is missing", %{params: params} do
        assert %Ecto.Changeset{valid?: false} =
                 params
                 |> Map.drop([unquote(field)])
                 |> ProductPromotion.changeset()
      end
    end
  end
end
