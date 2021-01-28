defmodule  Bonfire.UI.Contribution.CreateUnitForm do
  import Ecto.Changeset
  alias  Bonfire.Quantify.Units
  alias Bonfire.Quantify.Unit

  defstruct [:label, :symbol]

  @types %{
    label: :string,
    symbol: :string
  }

  def changeset(attrs \\ %{}) do
    {%__MODULE__{}, @types}
    |> cast(attrs, [:label, :symbol])
    |> validate_required([:label, :symbol])
    |> validate_length(:label, min: 2, max: 100)
  end

  def send(changeset, %{"label" => label, "symbol" => symbol} = _params, socket) do
    user = Map.get(socket.assigns, :current_user)
    case apply_action(changeset, :insert) do
      {:ok, _} ->

        with {:ok, unit} <- Units.create(user, %{label: label, symbol: symbol}) do
          {:ok, unit}
        else _e ->
          {nil, "Incorrect details. Please try again..."}
        end

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end