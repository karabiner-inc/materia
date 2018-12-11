defmodule Materia.AccountsTest do
  use Materia.DataCase
  doctest Materia.Accounts

  alias Materia.Accounts

  #describe "users" do
  #  alias Materia.Accounts.User
#
  #  @valid_attrs %{email: "some email", hashed_password: "some hashed_password", name: "some name", role: "some role"}
  #  @update_attrs %{email: "some updated email", hashed_password: "some updated hashed_password", name: "some updated name", role: "some updated role"}
  #  @invalid_attrs %{email: nil, hashed_password: nil, name: nil, role: nil}
#
  #  def user_fixture(attrs \\ %{}) do
  #    {:ok, user} =
  #      attrs
  #      |> Enum.into(@valid_attrs)
  #      |> Accounts.create_user()
#
  #    user
  #  end
#
  #  test "list_users/0 returns all users" do
  #    user = user_fixture()
  #    assert Accounts.list_users() == [user]
  #  end
#
  #  test "get_user!/1 returns the user with given id" do
  #    user = user_fixture()
  #    assert Accounts.get_user!(user.id) == user
  #  end
#
  #  test "create_user/1 with valid data creates a user" do
  #    assert {:ok, %User{} = user} = Accounts.create_user(@valid_attrs)
  #    assert user.email == "some email"
  #    assert user.hashed_password == "some hashed_password"
  #    assert user.name == "some name"
  #    assert user.role == "some role"
  #  end
#
  #  test "create_user/1 with invalid data returns error changeset" do
  #    assert {:error, %Ecto.Changeset{}} = Accounts.create_user(@invalid_attrs)
  #  end
#
  #  test "update_user/2 with valid data updates the user" do
  #    user = user_fixture()
  #    assert {:ok, user} = Accounts.update_user(user, @update_attrs)
  #    assert %User{} = user
  #    assert user.email == "some updated email"
  #    assert user.hashed_password == "some updated hashed_password"
  #    assert user.name == "some updated name"
  #    assert user.role == "some updated role"
  #  end
#
  #  test "update_user/2 with invalid data returns error changeset" do
  #    user = user_fixture()
  #    assert {:error, %Ecto.Changeset{}} = Accounts.update_user(user, @invalid_attrs)
  #    assert user == Accounts.get_user!(user.id)
  #  end
#
  #  test "delete_user/1 deletes the user" do
  #    user = user_fixture()
  #    assert {:ok, %User{}} = Accounts.delete_user(user)
  #    assert_raise Ecto.NoResultsError, fn -> Accounts.get_user!(user.id) end
  #  end
#
  #  test "change_user/1 returns a user changeset" do
  #    user = user_fixture()
  #    assert %Ecto.Changeset{} = Accounts.change_user(user)
  #  end
  #end
#
  #describe "grants" do
  #  alias Materia.Accounts.Grant
#
  #  @valid_attrs %{request_path: "some request_path", role: "some role"}
  #  @update_attrs %{request_path: "some updated request_path", role: "some updated role"}
  #  @invalid_attrs %{request_path: nil, role: nil}
#
  #  def grant_fixture(attrs \\ %{}) do
  #    {:ok, grant} =
  #      attrs
  #      |> Enum.into(@valid_attrs)
  #      |> Accounts.create_grant()
#
  #    grant
  #  end
#
  #  test "list_grants/0 returns all grants" do
  #    grant = grant_fixture()
  #    assert Accounts.list_grants() == [grant]
  #  end
#
  #  test "get_grant!/1 returns the grant with given id" do
  #    grant = grant_fixture()
  #    assert Accounts.get_grant!(grant.id) == grant
  #  end
#
  #  test "create_grant/1 with valid data creates a grant" do
  #    assert {:ok, %Grant{} = grant} = Accounts.create_grant(@valid_attrs)
  #    assert grant.request_path == "some request_path"
  #    assert grant.role == "some role"
  #  end
#
  #  test "create_grant/1 with invalid data returns error changeset" do
  #    assert {:error, %Ecto.Changeset{}} = Accounts.create_grant(@invalid_attrs)
  #  end
#
  #  test "update_grant/2 with valid data updates the grant" do
  #    grant = grant_fixture()
  #    assert {:ok, grant} = Accounts.update_grant(grant, @update_attrs)
  #    assert %Grant{} = grant
  #    assert grant.request_path == "some updated request_path"
  #    assert grant.role == "some updated role"
  #  end
#
  #  test "update_grant/2 with invalid data returns error changeset" do
  #    grant = grant_fixture()
  #    assert {:error, %Ecto.Changeset{}} = Accounts.update_grant(grant, @invalid_attrs)
  #    assert grant == Accounts.get_grant!(grant.id)
  #  end
#
  #  test "delete_grant/1 deletes the grant" do
  #    grant = grant_fixture()
  #    assert {:ok, %Grant{}} = Accounts.delete_grant(grant)
  #    assert_raise Ecto.NoResultsError, fn -> Accounts.get_grant!(grant.id) end
  #  end
#
  #  test "change_grant/1 returns a grant changeset" do
  #    grant = grant_fixture()
  #    assert %Ecto.Changeset{} = Accounts.change_grant(grant)
  #  end
  #end

  # describe "addresses" do
  #   alias Materia.Accounts.Address

  #   @valid_attrs %{address1: "some address1", address2: "some address2", latitude: "120.5", location: "some location", longitude: "120.5", zip_code: "some zip_code"}
  #   @update_attrs %{address1: "some updated address1", address2: "some updated address2", latitude: "456.7", location: "some updated location", longitude: "456.7", zip_code: "some updated zip_code"}
  #   @invalid_attrs %{address1: nil, address2: nil, latitude: nil, location: nil, longitude: nil, zip_code: nil}

  #   def address_fixture(attrs \\ %{}) do
  #     {:ok, address} =
  #       attrs
  #       |> Enum.into(@valid_attrs)
  #       |> Accounts.create_address()

  #     address
  #   end

  #   test "list_addresses/0 returns all addresses" do
  #     address = address_fixture()
  #     assert Accounts.list_addresses() == [address]
  #   end

  #   test "get_address!/1 returns the address with given id" do
  #     address = address_fixture()
  #     assert Accounts.get_address!(address.id) == address
  #   end

  #   test "create_address/1 with valid data creates a address" do
  #     assert {:ok, %Address{} = address} = Accounts.create_address(@valid_attrs)
  #     assert address.address1 == "some address1"
  #     assert address.address2 == "some address2"
  #     assert address.latitude == Decimal.new("120.5")
  #     assert address.location == "some location"
  #     assert address.longitude == Decimal.new("120.5")
  #     assert address.zip_code == "some zip_code"
  #   end

  #   test "create_address/1 with invalid data returns error changeset" do
  #     assert {:error, %Ecto.Changeset{}} = Accounts.create_address(@invalid_attrs)
  #   end

  #   test "update_address/2 with valid data updates the address" do
  #     address = address_fixture()
  #     assert {:ok, address} = Accounts.update_address(address, @update_attrs)
  #     assert %Address{} = address
  #     assert address.address1 == "some updated address1"
  #     assert address.address2 == "some updated address2"
  #     assert address.latitude == Decimal.new("456.7")
  #     assert address.location == "some updated location"
  #     assert address.longitude == Decimal.new("456.7")
  #     assert address.zip_code == "some updated zip_code"
  #   end

  #   test "update_address/2 with invalid data returns error changeset" do
  #     address = address_fixture()
  #     assert {:error, %Ecto.Changeset{}} = Accounts.update_address(address, @invalid_attrs)
  #     assert address == Accounts.get_address!(address.id)
  #   end

  #   test "delete_address/1 deletes the address" do
  #     address = address_fixture()
  #     assert {:ok, %Address{}} = Accounts.delete_address(address)
  #     assert_raise Ecto.NoResultsError, fn -> Accounts.get_address!(address.id) end
  #   end

  #   test "change_address/1 returns a address changeset" do
  #     address = address_fixture()
  #     assert %Ecto.Changeset{} = Accounts.change_address(address)
  #   end
  # end
end
