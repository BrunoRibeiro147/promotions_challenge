defmodule HorizonChallenge.Promotions.Services.ApplyPromotion do
  @moduledoc """
  Service for apply the promotion on products
  """

  alias HorizonChallenge.Schemas.Promotions.Repository

  @spec execute(
          checkout :: %{
            code: String.t(),
            price: Money.t(),
            final_price: Money.t(),
            promotion_applied: boolean(),
            quantity: integer()
          },
          princing_rules :: list(String.t())
        ) :: {:ok, map()}
  def execute(checkout, pricing_rules) do
    promotions_applied =
      pricing_rules
      |> Repository.list_promotions_by_code()
      |> apply_promotion(checkout)

    {:ok, promotions_applied}
  end

  def apply_promotion([], checkout), do: checkout

  def apply_promotion([promotion | tail], checkout) do
    promotion_products_code = get_products_code_of_promotion(promotion)

    promotions_applied_products =
      verify_applicable_promotion_to_product(checkout, promotion, promotion_products_code, [])

    apply_promotion(tail, promotions_applied_products)
  end

  defp verify_applicable_promotion_to_product([], _promotion, _, acc), do: acc

  defp verify_applicable_promotion_to_product([product | tail], promotion, promotion_codes, acc) do
    case product.code in promotion_codes do
      true ->
        product = apply_promotion_to_product(promotion, product)
        verify_applicable_promotion_to_product(tail, promotion, promotion_codes, acc ++ [product])

      false ->
        product = calculate_final_price(product)
        verify_applicable_promotion_to_product(tail, promotion, promotion_codes, acc ++ [product])
    end
  end

  defp get_products_code_of_promotion(promotion) do
    Enum.map(promotion.products, fn product ->
      product.code
    end)
  end

  def calculate_final_price(%{promotion_applied: true} = product), do: product

  def calculate_final_price(product) do
    final_price = sum_product_price(product)

    Map.put(product, :final_price, final_price)
  end

  def sum_product_price(product) do
    Money.multiply(product.price, product.quantity)
  end

  defp apply_promotion_to_product(promotion, product) do
    case product.quantity >= promotion.amount_for_enable_promotion do
      true ->
        product_with_applied_promotion =
          validate_products_affected_by_promotion(promotion, product)

        Map.put(product_with_applied_promotion, :promotion_applied, true)

      false ->
        product
    end
  end

  defp validate_products_affected_by_promotion(promotion, product) do
    case promotion.products_affected_by_promotion do
      "all" ->
        apply_promotion_to_all_products(promotion, product)

      _value ->
        apply_promotion_to_limited_products(promotion, product)
    end
  end

  defp apply_promotion_to_all_products(promotion, product) do
    discount = calculate_discount(promotion.discount_percentage, product.price)

    price_with_discount = Money.subtract(product.price, discount)

    final_price = Money.multiply(price_with_discount, product.quantity)

    Map.put(product, :final_price, final_price)
  end

  defp apply_promotion_to_limited_products(promotion, product) do
    quantity_of_activated_promotions =
      Float.floor(product.quantity / promotion.amount_for_enable_promotion)

    quantity_of_products_to_apply_discount =
      quantity_of_activated_promotions *
        String.to_integer(promotion.products_affected_by_promotion)

    discount = calculate_discount(promotion.discount_percentage, product.price)

    total_price = sum_product_price(product)

    final_discount = Money.multiply(discount, quantity_of_products_to_apply_discount)

    final_price = Money.subtract(total_price, final_discount)

    Map.put(product, :final_price, final_price)
  end

  defp calculate_discount(discount_percentage, price) do
    price
    |> Money.multiply(discount_percentage)
    |> Money.divide(100)
    |> List.first()
  end
end
