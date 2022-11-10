# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     HorizonChallenge.Repo.insert!(%HorizonChallenge.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

%{id: product_id_1} =
  %{
    code: "VOUCHER",
    name: "Voucher",
    price: Money.new(500, :EUR)
  }
  |> HorizonChallenge.Schemas.Product.changeset()
  |> HorizonChallenge.Repo.insert!()

%{id: product_id_2} =
  %{
    code: "TSHIRT",
    name: "T-Shirt",
    price: Money.new(2000, :EUR)
  }
  |> HorizonChallenge.Schemas.Product.changeset()
  |> HorizonChallenge.Repo.insert!()

%{
  code: "MUG",
  name: "Coffee Mug",
  price: Money.new(750, :EUR)
}
|> HorizonChallenge.Schemas.Product.changeset()
|> HorizonChallenge.Repo.insert!()

%{id: promotion_id_1} =
  %{
    code: "2-for-1",
    name: "Buy 2 items and gain 1 for free",
    amount_for_enable_promotion: 2,
    products_affected_by_promotion: "1",
    discount_percentage: 100
  }
  |> HorizonChallenge.Schemas.Promotion.changeset()
  |> HorizonChallenge.Repo.insert!()

%{id: promotion_id_2} =
  %{
    code: "discount_on_bulk",
    name: "Buy 3 itens and gain a discount",
    amount_for_enable_promotion: 2,
    products_affected_by_promotion: "1",
    discount_percentage: 5
  }
  |> HorizonChallenge.Schemas.Promotion.changeset()
  |> HorizonChallenge.Repo.insert!()

%{
  product_id: product_id_1,
  promotion_id: promotion_id_1
}
|> HorizonChallenge.Schemas.ProductPromotion.changeset()
|> HorizonChallenge.Repo.insert!()

%{
  product_id: product_id_2,
  promotion_id: promotion_id_2
}
|> HorizonChallenge.Schemas.ProductPromotion.changeset()
|> HorizonChallenge.Repo.insert!()
