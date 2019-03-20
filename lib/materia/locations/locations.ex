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
  iex(2)> MateriaWeb.AddressView.render("index.json", %{addresses: addresses})
  [
  %{
    address1: "福岡市中央区",
    address2: "港 x-x-xx",
    id: 1,
    latitude: nil,
    location: "福岡県",
    lock_version: 0,
    longitude: nil,
    organization: nil,
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
      role: "admin",
      status: 1
    },
    zip_code: "810-ZZZZ"
  },
  %{
    address1: "福岡市中央区",
    address2: "大名 x-x-xx",
    id: 2,
    latitude: nil,
    location: "福岡県",
    lock_version: 0,
    longitude: nil,
    organization: nil,
    subject: "billing",
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
      role: "admin",
      status: 1
    },
    zip_code: "810-ZZZZ"
  },
  %{
    address1: "福岡市中央区",
    address2: "天神 x-x-xx",
    id: 3,
    latitude: nil,
    location: "福岡県",
    lock_version: 0,
    longitude: nil,
    organization: %{
      addresses: [],
      back_ground_img_url: "https://hogehoge.com/ib_img.jpg",
      hp_url: "https://hogehoge.inc",
      id: 1,
      lock_version: 1,
      name: "hogehoge.inc",
      one_line_message: "let's do this.",
      phone_number: nil,
      profile_img_url: "https://hogehoge.com/prof_img.jpg",
      status: 1,
      users: []
    },
    subject: "registry",
    user: nil,
    zip_code: "810-ZZZZ"
  },
  %{
    address1: "北九州市小倉北区",
    address2: "浅野 x-x-xx",
    id: 4,
    latitude: nil,
    location: "福岡県",
    lock_version: 0,
    longitude: nil,
    organization: %{
      addresses: [],
      back_ground_img_url: "https://hogehoge.com/ib_img.jpg",
      hp_url: "https://hogehoge.inc",
      id: 1,
      lock_version: 1,
      name: "hogehoge.inc",
      one_line_message: "let's do this.",
      phone_number: nil,
      profile_img_url: "https://hogehoge.com/prof_img.jpg",
      status: 1,
      users: []
    },
    subject: "branch",
    user: nil,
    zip_code: "812-ZZZZ"
  }
]

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
    address2: "港 x-x-xx",
    id: 1,
    latitude: nil,
    location: "福岡県",
    lock_version: 0,
    longitude: nil,
    organization: nil,
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
      role: "admin",
      status: 1
    },
    zip_code: "810-ZZZZ"
  }
  ```


  """
  def get_address!(id) do
    repo = Application.get_env(:materia, :repo)
    Address
    |>repo.get!(id)
    |> repo.preload([:user, :organization])
  end

  @doc """
  Creates a address.

  ## Examples

  ```
  iex(1)> {:ok, address} = Materia.Locations.create_address(%{subject: "living"})
  iex(2)> MateriaWeb.AddressView.render("show.json", %{address: address}) |> Map.delete(:id)
  %{
  address1: nil,
  address2: nil,
  latitude: nil,
  location: nil,
  lock_version: 0,
  longitude: nil,
  organization: nil,
  subject: "living",
  user: [],
  zip_code: nil
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
    address2: "港 x-x-xx",
    id: 1,
    latitude: nil,
    location: "Fukuoka City",
    lock_version: 1,
    longitude: nil,
    organization: nil,
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
      role: "admin",
      status: 1
    },
    zip_code: "810-ZZZZ"
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
  iex(3)> addresses = Materia.Locations.list_addresses()
  iex(4)> MateriaWeb.AddressView.render("index.json", %{addresses: addresses})
  [
    %{
      address1: "福岡市中央区",
      address2: "大名 x-x-xx",
      id: 2,
      latitude: nil,
      location: "福岡県",
      lock_version: 0,
      longitude: nil,
      organization: nil,
      subject: "billing",
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
        role: "admin",
        status: 1
      },
      zip_code: "810-ZZZZ"
    },
    %{
      address1: "福岡市中央区",
      address2: "天神 x-x-xx",
      id: 3,
      latitude: nil,
      location: "福岡県",
      lock_version: 0,
      longitude: nil,
      organization: %{
        addresses: [],
        back_ground_img_url: "https://hogehoge.com/ib_img.jpg",
        hp_url: "https://hogehoge.inc",
        id: 1,
        lock_version: 1,
        name: "hogehoge.inc",
        one_line_message: "let's do this.",
        phone_number: nil,
        profile_img_url: "https://hogehoge.com/prof_img.jpg",
        status: 1,
        users: []
      },
      subject: "registry",
      user: nil,
      zip_code: "810-ZZZZ"
    },
    %{
      address1: "北九州市小倉北区",
      address2: "浅野 x-x-xx",
      id: 4,
      latitude: nil,
      location: "福岡県",
      lock_version: 0,
      longitude: nil,
      organization: %{
        addresses: [],
        back_ground_img_url: "https://hogehoge.com/ib_img.jpg",
        hp_url: "https://hogehoge.inc",
        id: 1,
        lock_version: 1,
        name: "hogehoge.inc",
        one_line_message: "let's do this.",
        phone_number: nil,
        profile_img_url: "https://hogehoge.com/prof_img.jpg",
        status: 1,
        users: []
      },
      subject: "branch",
      user: nil,
      zip_code: "812-ZZZZ"
    }
  ]
  ```


  """
  def delete_address(%Address{} = address) do
    repo = Application.get_env(:materia, :repo)
    repo.delete(address)
  end

end
