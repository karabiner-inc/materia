defmodule ServicexWeb.AddressControllerTest do
  use ServicexWeb.ConnCase

  alias Servicex.Accounts
  alias Servicex.Accounts.Address

  @create_attrs %{address1: "some address1", address2: "some address2", latitud: "120.5", location: "some location", longitude: "120.5", zip_code: "some zip_code", subject: "some subject"}
  @update_attrs %{address1: "some updated address1", address2: "some updated address2", latitud: "456.7", location: "some updated location", longitude: "456.7", zip_code: "some updated zip_code" , subject: "some updated subject"}
  @invalid_attrs %{address1: nil, address2: nil, latitud: nil, location: nil, longitude: nil, zip_code: nil}
  @admin_user_attrs %{
    "name": "hogehoge",
    "email": "hogehoge@example.com",
    "password": "hogehoge",
    "role": "admin"
  }
  def fixture(:address) do
    {:ok, address} = Accounts.create_address(@create_attrs)
    address
  end

  setup %{conn: conn} do
    {:ok, token: token } = log_in("")
    conn = conn
    |> put_req_header("accept", "application/json")
    |> put_req_header(conn, "accept", "application/json")
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  defp log_in(_) do
    token_conn = post conn, authenticator_path(conn, :sign_in), @admin_user_attrs
      %{"token" => token } = json_response(token_conn, 201)
    {:ok, token: token}
  end

  describe "index" do
    test "lists all addresses", %{conn: conn} do
      conn = get conn, address_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "my addresses" do
    test "lists my addresses", %{conn: conn} do
      conn = get conn, address_path(conn, :my_addresses)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create address" do
    test "renders address when data is valid", %{conn: conn} do
      conn = post conn, address_path(conn, :create), address: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, address_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "address1" => "some address1",
        "address2" => "some address2",
        "latitud" => "120.5",
        "location" => "some location",
        "longitude" => "120.5",
        "zip_code" => "some zip_code",
        "subject" => "some subject"
      }
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, address_path(conn, :create), address: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update address" do
    setup [:create_address]

    test "renders address when data is valid", %{conn: conn, address: %Address{id: id} = address} do
      conn = put conn, address_path(conn, :update, address), address: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, address_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "address1" => "some updated address1",
        "address2" => "some updated address2",
        "latitud" => "456.7",
        "location" => "some updated location",
        "longitude" => "456.7",
        "zip_code" => "some updated zip_code",
        "subject" => "some updated subject"
      }
    end

    test "renders errors when data is invalid", %{conn: conn, address: address} do
      conn = put conn, address_path(conn, :update, address), address: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete address" do
    setup [:create_address]

    test "deletes chosen address", %{conn: conn, address: address} do
      conn = delete conn, address_path(conn, :delete, address)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, address_path(conn, :show, address)
      end
    end
  end

  defp create_address(_) do
    address = fixture(:address)
    {:ok, address: address}
  end
end
