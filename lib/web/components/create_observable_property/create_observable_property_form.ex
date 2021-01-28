defmodule  Bonfire.UI.Contribution.CreateObservablePropertyForm do
  import Ecto.Changeset
  alias ValueFlows.Observe.ObservableProperties

  defstruct [:name, :note]

  @types %{
    name: :string,
    note: :string
  }

  def changeset(attrs \\ %{}) do
    {%__MODULE__{}, @types}
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> validate_length(:name, min: 2, max: 100)
  end

  def send(changeset, %{"name" => name, "note" => note} = _params, socket) do
    user = Map.get(socket.assigns, :current_user)
    case apply_action(changeset, :insert) do
      {:ok, _} ->

        with {:ok, property} <- ObservableProperties.create(user, %{name: name, note: note}) do
          {:ok, property}
        else _e ->
          {nil, "Incorrect details. Please try again..."}
        end

      {:error, changeset} ->
        {:error, changeset}
    end
  end
end
