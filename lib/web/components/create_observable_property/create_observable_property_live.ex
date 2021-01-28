defmodule Bonfire.UI.Contribution.CreateObservablePropertyLive do
  use Bonfire.Web, :live_component
  alias Bonfire.UI.Contribution.CreateObservablePropertyForm


  def mount(socket) do
    changeset = CreateObservablePropertyForm.changeset()
    {:ok, socket
    |> assign(
      changeset: changeset
    )}
  end

  def handle_event("validate_property", %{"create_observable_property_form" => params}, socket) do
    changeset = CreateObservablePropertyForm.changeset(params)
    changeset = Map.put(changeset, :action, :insert)
    socket = assign(socket, changeset: changeset)
    {:noreply, socket}
  end

  def handle_event("submit_property",  %{"create_observable_property_form" => params}, socket) do
    changeset = CreateObservablePropertyForm.changeset(params)

    case CreateObservablePropertyForm.send(changeset, params, socket) do
      {:ok, property} ->
        {:noreply,
         socket
         |> put_flash(:info, "Property successfully created!")
         |> assign(all_properties: [property] ++ socket.assigns.all_properties)
       }

      {:error, changeset} ->
        {:noreply, assign(socket, changeset_property: changeset)}

      {_, message} ->
        {:noreply,
         socket
         |> put_flash(:error, message)}
         |> assign(changeset: CreateObservablePropertyForm.changeset(%{}))
    end
  end

end
