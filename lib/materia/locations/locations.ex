defmodule Materia.Locations do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Materia.Locations.Address
  alias MateriaUtils.Ecto.EctoUtil

  @doc """
  Returns the list of addresses.


  ```
  iex(1)> addresses = Materia.Locations.list_addresses()
  iex(2)> MateriaWeb.AddressView.render("show.json", %{address: addresses |> Enum.filter(fn x -> x.id == 1 end) |> hd})
  %{
    address1: "福岡市中央区",
    address1_p: "address1_p",
    address2: "港 x-x-xx",
    address2_p: "address2_p",
    address3: "address3",
    address3_p: "address3_p",
    id: 1,
    latitude: nil,
    location: "福岡県",
    lock_version: 0,
    longitude: nil,
    notation_name: "notation_name",
    notation_org_name: "notation_org_name",
    notation_org_name_p: "notation_org_name_p",
    notation_name_p: "notation_name_p",
    organization: nil,
    phone_number: "phone_number",
    fax_number: "fax_number",
    subject: "living",
    user: %{
      addresses: [],
      back_ground_img_url: nil,
      descriptions: nil,
      email: "hogehoge@example.com",
      external_user_id: nil,
      icon_img_url: nil,
      id: 1,
      lock_version: 2,
      name: "hogehoge",
      organization: nil,
      phone_number: nil,
      fax_number: "fax_number",
      name_p: "name_p",
      role: "admin",
      status: 1
    },
    zip_code: "810-ZZZZ",
    area_code: nil,
    status: 1
  }

  ```
  """
  def list_addresses do
    repo = Application.get_env(:materia, :repo)

    Address
    |> repo.all()
    |> repo.preload([:user, :organization])
  end

  @doc """
  Gets a single address.

  Raises `Ecto.NoResultsError` if the Address does not exist.

  ```
  iex(1)> address = Materia.Locations.get_address!(1)
  iex(2)> MateriaWeb.AddressView.render("show.json", %{address: address})
  %{
    address1: "福岡市中央区",
    address1_p: "address1_p",
    address2: "港 x-x-xx",
    address2_p: "address2_p",
    address3: "address3",
    address3_p: "address3_p",
    id: 1,
    latitude: nil,
    location: "福岡県",
    lock_version: 0,
    longitude: nil,
    notation_name: "notation_name",
    notation_org_name: "notation_org_name",
    notation_org_name_p: "notation_org_name_p",
    notation_name_p: "notation_name_p",
    organization: nil,
    phone_number: "phone_number",
    fax_number: "fax_number",
    subject: "living",
    user: %{
      addresses: [],
      back_ground_img_url: nil,
      descriptions: nil,
      email: "hogehoge@example.com",
      external_user_id: nil,
      icon_img_url: nil,
      id: 1,
      lock_version: 2,
      name: "hogehoge",
      organization: nil,
      phone_number: nil,
      fax_number: "fax_number",
      name_p: "name_p",
      role: "admin",
      status: 1
    },
    zip_code: "810-ZZZZ",
    area_code: nil,
    status: 1
  }
  ```


  """
  def get_address!(id) do
    repo = Application.get_env(:materia, :repo)

    Address
    |> repo.get!(id)
    |> repo.preload([:user, :organization])
  end

  @doc """
  Creates a address.

  ## Examples

  ```
  iex(1)> {:ok, address} = Materia.Locations.create_address(%{subject: "living", area_code: "TEST"})
  iex(2)> MateriaWeb.AddressView.render("show.json", %{address: address}) |> Map.delete(:id)
  %{
    address1: nil,
    address1_p: nil,
    address2: nil,
    address2_p: nil,
    address3: nil,
    address3_p: nil,
    latitude: nil,
    location: nil,
    lock_version: 0,
    longitude: nil,
    notation_name: nil,
    notation_org_name: nil,
    notation_org_name_p: nil,
    notation_name_p: nil,
    organization: nil,
    phone_number: nil,
    fax_number: nil,
    subject: "living",
    user: [],
    zip_code: nil,
    area_code: "TEST",
    status: 1
  }

  ```

  """
  def create_address(attrs \\ %{}) do
    repo = Application.get_env(:materia, :repo)

    %Address{}
    |> Address.create_changeset(attrs)
    |> repo.insert()
  end

  @doc """
  Updates a address.

  ## Examples

  ```
  iex(1)> address = Materia.Locations.get_address!(1)
  iex(2)> {:ok, updated_address} = Materia.Locations.update_address(address, %{location: "Fukuoka City"})
  iex(3)> MateriaWeb.AddressView.render("show.json", %{address: updated_address})
  %{
    address1: "福岡市中央区",
    address1_p: "address1_p",
    address2: "港 x-x-xx",
    address2_p: "address2_p",
    address3: "address3",
    address3_p: "address3_p",
    id: 1,
    latitude: nil,
    location: "Fukuoka City",
    lock_version: 1,
    longitude: nil,
    notation_name: "notation_name",
    notation_org_name: "notation_org_name",
    notation_org_name_p: "notation_org_name_p",
    notation_name_p: "notation_name_p",
    organization: nil,
    phone_number: "phone_number",
    fax_number: "fax_number",
    subject: "living",
    user: %{
      addresses: [],
      back_ground_img_url: nil,
      descriptions: nil,
      email: "hogehoge@example.com",
      external_user_id: nil,
      icon_img_url: nil,
      id: 1,
      lock_version: 2,
      name: "hogehoge",
      organization: nil,
      phone_number: nil,
      fax_number: "fax_number",
      name_p: "name_p",
      role: "admin",
      status: 1
    },
    zip_code: "810-ZZZZ",
    area_code: nil,
    status: 1
  }
  ```

  """
  def update_address(%Address{} = address, attrs) do
    repo = Application.get_env(:materia, :repo)

    address
    |> Address.update_changeset(attrs)
    |> repo.update()
  end

  @doc """
  Deletes a Address.

  ## Examples

  ```
  iex(1)> address = Materia.Locations.get_address!(1)
  iex(2)> {:ok, address} = Materia.Locations.delete_address(address)
  iex(3)> Materia.Locations.list_addresses() |> Enum.count()
  3
  ```

  """
  def delete_address(%Address{} = address) do
    repo = Application.get_env(:materia, :repo)
    repo.delete(address)
  end
end
