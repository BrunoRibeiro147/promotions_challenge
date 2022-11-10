defmodule HorizonChallenge.Schemas.Promotion do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(name code amount_for_enable_promotion discount_percentage products_affected_by_promotion)a
  @optional_fields ~w()a

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :id
  @timestamps_opts [type: :utc_datetime_usec]

  @type t :: %__MODULE__{}

  alias HorizonChallenge.Schemas.Product
  alias HorizonChallenge.Schemas.ProductPromotion

  schema "promotions" do
    field(:name, :string)
    field(:code, :string)
    field(:amount_for_enable_promotion, :integer)
    field(:discount_percentage, :integer)
    field(:products_affected_by_promotion, :string)

    many_to_many(
      :products,
      Product,
      join_through: ProductPromotion,
      on_replace: :delete
    )

    timestamps()
  end

  @spec changeset(schema :: __MODULE__.t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(schema \\ %__MODULE__{}, attrs) do
    schema
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end

  @spec upsert_promotion_products(promotion :: __MODULE__.t(), product :: Product.t()) ::
          Ecto.Changeset.t()
  def upsert_promotion_products(promotion, product) do
    promotion
    |> cast(%{}, @required_fields ++ @optional_fields)
    |> put_assoc(:products, [product | promotion.products])
  end
end
