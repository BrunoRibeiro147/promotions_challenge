defmodule HorizonChallenge.Schemas.ProductPromotion do
  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(promotion_id product_id)a
  @optional_fields ~w()a

  @primary_key false
  @foreign_key_type :id
  @timestamps_opts [type: :utc_datetime_usec]

  @type t :: %__MODULE__{}

  alias HorizonChallenge.Schemas.Product
  alias HorizonChallenge.Schemas.Promotion

  schema "products_promotions" do
    belongs_to(:product, Product)
    belongs_to(:promotion, Promotion)

    timestamps()
  end

  @spec changeset(schema :: __MODULE__.t(), attrs :: map()) :: Ecto.Changeset.t()
  def changeset(schema \\ %__MODULE__{}, attrs) do
    schema
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
  end
end
