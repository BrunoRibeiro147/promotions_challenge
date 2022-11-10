defmodule HorizonChallenge.Schemas.ProductTest do
  use HorizonChallenge.DataCase, async: true

  alias HorizonChallenge.Schemas.Product

  describe "changeset/2" do
    setup do
      params = %{
        name: "Tshirt",
        code: "TSHIRT",
        price: Money.new(2000)
      }

      %{params: params}
    end

    test "returns an valid changeset if all params are valid", %{params: params} do
      assert %Ecto.Changeset{valid?: true} = Product.changeset(params)
    end

    for field <- [:name, :code, :price] do
      test "returns an invalid changeset if #{field} is missing", %{params: params} do
        assert %Ecto.Changeset{valid?: false} =
                 params
                 |> Map.drop([unquote(field)])
                 |> Product.changeset()
      end
    end
  end
end
