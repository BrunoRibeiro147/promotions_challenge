defmodule HorizonChallenge.Checkout.Services.CalculateTotal do
  @moduledoc """
  Service to calculate total of a checkout
  """

  alias HorizonChallenge.Promotions.Services.ApplyPromotion, as: ApplyPromotionService
  alias HorizonChallenge.Schemas.Products.Repository

  def execute(scanned_items, pricing_rules) do
    scanned_items
    |> Repository.list_products_by_code()
    |> validate_products(scanned_items, pricing_rules)
  end

  defp validate_products([], _scanned_items, _pricing_rules), do: {:error, :invalid_products}

  defp validate_products(products, scanned_items, pricing_rules) do
    products_codes = Enum.map(products, & &1.code)

    existents_products = verify_if_product_exists(scanned_items, products, products_codes, [])

    existents_products
    |> calculate_products_price()
    |> ApplyPromotionService.execute(pricing_rules)
    |> calculate_purchase_total()
  end

  defp calculate_products_price(products) do
    Enum.reduce(products, [], fn product, acc ->
      updated_product =
        Map.put(product, :final_price, Money.multiply(product.price, product.quantity))

      acc ++ [updated_product]
    end)
  end

  defp calculate_purchase_total({:ok, products}) do
    purchase_total =
      Enum.reduce(products, 0, fn product, acc ->
        Money.add(product.final_price, acc)
      end)

    format_purchase = Money.to_string(purchase_total, separator: ".", delimiter: ",")

    checkout = %{
      products: products,
      total: format_purchase
    }

    {:ok, checkout}
  end

  def verify_if_product_exists([], _product, _products_codes, acc), do: acc

  def verify_if_product_exists([item | tail] = scanned_items, products, products_codes, acc) do
    filter_scanned_items = Enum.filter(tail, fn scan_item -> scan_item != item end)

    case item in products_codes do
      true ->
        mapped_product = map_product(item, products, scanned_items)

        verify_if_product_exists(
          filter_scanned_items,
          products,
          products_codes,
          acc ++ [mapped_product]
        )

      false ->
        verify_if_product_exists(filter_scanned_items, products, products_codes, acc)
    end
  end

  defp map_product(item, products, scanned_items) do
    product_quantity = Enum.count(scanned_items, &(&1 == item))

    product = Enum.find(products, fn product -> product.code == item end)

    %{
      code: product.code,
      price: product.price,
      promotion_applied: false,
      quantity: product_quantity
    }
  end
end
