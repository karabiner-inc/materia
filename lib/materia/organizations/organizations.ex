defmodule Materia.Organizations do
  @moduledoc """
  The Organizations context.
  """

  import Ecto.Query, warn: false
  alias Materia.Accounts

  alias Materia.Organizations.Organization
  alias MateriaUtils.Calendar.CalendarUtil
  alias MateriaUtils.Ecto.EctoUtil
  alias Materia.Errors.BusinessError

  require Logger

  @doc """
  Returns the list of organizations.

  ## Examples

  ```

  iex(1)> organizations = Materia.Organizations.list_organizations()
  iex(2)> MateriaWeb.OrganizationView.render("index.json", %{organizations: organizations})
  [
    %{
      addresses: [
        %{
          address1: "北九州市小倉北区",
          address1_p: "address1_p",
          address2: "浅野 x-x-xx",
          address2_p: "address2_p",
          address3: "address3",
          address3_p: "address3_p",
          id: 4,
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
          subject: "branch",
          user: [],
          zip_code: "812-ZZZZ"
        },
        %{
          address1: "福岡市中央区",
          address1_p: "address1_p",
          address2: "天神 x-x-xx",
          address2_p: "address2_p",
          address3: "address3",
          address3_p: "address3_p",
          id: 3,
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
          subject: "registry",
          user: [],
          zip_code: "810-ZZZZ"
        }
      ],
      back_ground_img_url: "https://hogehoge.com/ib_img.jpg",
      ext_organization_branch_id: "ext_organization_branch_id",
      ext_organization_id: "ext_organization_id",
      hp_url: "https://hogehoge.inc",
      id: 1,
      lock_version: 1,
      name: "hogehoge.inc",
      one_line_message: "let's do this.",
      phone_number: nil,
      fax_number: "fax_number",
      name_p: "name_p",
      profile_img_url: "https://hogehoge.com/prof_img.jpg",
      status: 1,
      users: []
    }
  ]

  ```

  """
  def list_organizations do
    repo = Application.get_env(:materia, :repo)

    Organization
    |> repo.all()
    |> repo.preload(:addresses)
  end

  @doc """

  ## Examples
  ```
  iex(1)> orgs = Materia.Organizations.list_organizations_by_params(%{"and" => [%{"name" => "hogehoge.inc"}]})
  iex(2)> length(orgs)
  1
  ```
  """
  def list_organizations_by_params(params) do
    repo = Application.get_env(:materia, :repo)

    repo
    |> EctoUtil.select_by_param(Organization, params)
    |> repo.preload(:addresses)
  end

  @doc """
  Gets a single organization.

  Raises `Ecto.NoResultsError` if the Organization does not exist.

  ## Examples

  ```
  iex(1)> organization = Materia.Organizations.get_organization!(1)
  iex(2)> MateriaWeb.OrganizationView.render("show.json", %{organization: organization})
  %{
    addresses: [
      %{
        address1: "北九州市小倉北区",
        address1_p: "address1_p",
        address2: "浅野 x-x-xx",
        address2_p: "address2_p",
        address3: "address3",
        address3_p: "address3_p",
        id: 4,
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
        subject: "branch",
        user: [],
        zip_code: "812-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address1_p: "address1_p",
        address2: "天神 x-x-xx",
        address2_p: "address2_p",
        address3: "address3",
        address3_p: "address3_p",
        id: 3,
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
        subject: "registry",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: "https://hogehoge.com/ib_img.jpg",
    ext_organization_branch_id: "ext_organization_branch_id",
    ext_organization_id: "ext_organization_id",
    hp_url: "https://hogehoge.inc",
    id: 1,
    lock_version: 1,
    name: "hogehoge.inc",
    one_line_message: "let's do this.",
    phone_number: nil,
    fax_number: "fax_number",
    name_p: "name_p",
    profile_img_url: "https://hogehoge.com/prof_img.jpg",
    status: 1,
    users: []
  }
  ```

  """
  def get_organization!(id) do
    repo = Application.get_env(:materia, :repo)

    Organization
    |> repo.get!(id)
    |> repo.preload(:addresses)
  end

  @doc """
  Creates a organization.

  ## Examples

  ```
  iex(1)> {:ok, organization} = Materia.Organizations.create_organization(%{name: "MyCompany"})
  iex(2)> MateriaWeb.OrganizationView.render("show.json", %{organization: organization}) |> Map.delete(:id)
  %{
    addresses: [],
    back_ground_img_url: nil,
    ext_organization_branch_id: nil,
    ext_organization_id: nil,
    hp_url: nil,
    lock_version: 1,
    name: "MyCompany",
    one_line_message: nil,
    phone_number: nil,
    fax_number: nil,
    name_p: nil,
    profile_img_url: nil,
    status: 1,
    users: []
  }
  ```

  """
  def create_organization(attrs \\ %{}) do
    repo = Application.get_env(:materia, :repo)

    %Organization{}
    |> Organization.changeset(attrs)
    |> repo.insert()
  end

  @doc """
  Creates a organization for user.

  ## Examples

  ```
  iex(1)> user = Materia.Accounts.get_user!(1)
  iex(2)> {:ok, organization} = Materia.Organizations.create_my_organization(%{}, user.id, %{name: "OurCompany"})
  iex(3)> MateriaWeb.OrganizationView.render("show.json", %{organization: organization}) |> Map.delete(:id)
  %{
    addresses: [],
    back_ground_img_url: nil,
    ext_organization_branch_id: nil,
    ext_organization_id: nil,
    hp_url: nil,
    lock_version: 0,
    name: "OurCompany",
    one_line_message: nil,
    phone_number: nil,
    name_p: nil,
    fax_number: nil,
    profile_img_url: nil,
    status: 1,
    users: [
      %{
        addresses: [],
        back_ground_img_url: nil,
        descriptions: nil,
        email: "hogehoge@example.com",
        external_user_id: nil,
        icon_img_url: nil,
        id: 1,
        lock_version: 3,
        name: "hogehoge",
        organization: nil,
        phone_number: nil,
        fax_number: "fax_number",
        name_p: "name_p",
        role: "admin",
        status: 1
      }
    ]
  }
  ```

  """
  def create_my_organization(_result, user_id, attrs \\ %{}) do
    repo = Application.get_env(:materia, :repo)
    user = Accounts.get_user!(user_id)
    organization = Ecto.build_assoc(user, :organization, attrs)
    {:ok, inserted_organization} = repo.insert(organization)
    {:ok, updated_user} = Accounts.update_user(user, %{organization_id: inserted_organization.id})
    preloaded_organization = repo.preload(inserted_organization, [:users, :addresses])
    {:ok, preloaded_organization}
  end

  @doc """
  Updates a organization.

  ## Examples

  ```
  iex(1)> organization = Materia.Organizations.get_organization!(1)
  iex(2)> {:ok, updated_organization} = Materia.Organizations.update_organization(organization, %{name: "UpdatedCompany"})
  iex(3)> MateriaWeb.OrganizationView.render("show.json", %{organization: updated_organization})
  %{
    addresses: [
      %{
        address1: "北九州市小倉北区",
        address1_p: "address1_p",
        address2: "浅野 x-x-xx",
        address2_p: "address2_p",
        address3: "address3",
        address3_p: "address3_p",
        id: 4,
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
        subject: "branch",
        user: [],
        zip_code: "812-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address1_p: "address1_p",
        address2: "天神 x-x-xx",
        address2_p: "address2_p",
        address3: "address3",
        address3_p: "address3_p",
        id: 3,
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
        subject: "registry",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: "https://hogehoge.com/ib_img.jpg",
    ext_organization_branch_id: "ext_organization_branch_id",
    ext_organization_id: "ext_organization_id",
    hp_url: "https://hogehoge.inc",
    id: 1,
    lock_version: 2,
    name: "UpdatedCompany",
    one_line_message: "let's do this.",
    phone_number: nil,
    name_p: "name_p",
    fax_number: "fax_number",
    profile_img_url: "https://hogehoge.com/prof_img.jpg",
    status: 1,
    users: []
  }
  ```

  """
  def update_organization(%Organization{} = organization, attrs) do
    repo = Application.get_env(:materia, :repo)

    organization
    |> Organization.update_changeset(attrs)
    |> repo.update()
  end

  @doc """
  Deletes a Organization.

  ## Examples

  ```
  iex(1)> {:ok, organization} = Materia.Organizations.create_organization(%{name: "test_delete_organiztion_001"})
  iex(2)> {:ok, organization} = Materia.Organizations.delete_organization(organization)
  iex(3)> organizations = Materia.Organizations.list_organizations()
  iex(4)> MateriaWeb.OrganizationView.render("index.json", %{organizations: organizations}) |> length()
  1
  ```

  """
  def delete_organization(%Organization{} = organization) do
    repo = Application.get_env(:materia, :repo)
    repo.delete(organization)
  end

  @doc """
  Logical Delete a Organization.

  iex(1)> organization = Materia.Organizations.get_organization!(1)
  iex(2)> {:ok, result} = Materia.Organizations.logical_delete(nil, organization, 1)
  iex(3)> view = MateriaWeb.OrganizationView.render("show.json", %{organization: result})
  iex(4)> %{status: view.status, lock_version: view.lock_version}
  %{status: 9, lock_version: 2}
  """
  def logical_delete(_result, organization, lock_version) do
    organization
    |> update_organization(%{"status" => Organization.status().unactive, "lock_version" => lock_version})
  end
end
