defmodule HorizonChallenge.Schemas.Product do
  @moduledoc """
  Schema for Product
  """

  use Ecto.Schema
  import Ecto.Changeset

  @required_fields ~w(name code price)a
  @optional_fields ~w()a

  @primary_key {:id, :id, autogenerate: true}
  @foreign_key_type :id
  @timestamps_opts [type: :utc_datetime_usec]

  @type t :: %__MODULE__{}

  alias HorizonChallenge.Schemas.ProductPromotion
  alias HorizonChallenge.Schemas.Promotion

  schema "products" do
    field(:name, :string)
    field(:code, :string)
    field(:price, Money.Ecto.Amount.Type)

    many_to_many(
      :promotion,
      Promotion,
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

  # @spec upsert_user_courses(user :: __MODULE__.t(), courses :: Course.t()) :: Ecto.Changeset.t()
  # def upsert_user_courses(user, course) do
  #  user
  #  |> cast(%{}, @required_fields ++ @optional_fields)
  #  |> put_assoc(:courses, [course | user.courses])
  # end
end
