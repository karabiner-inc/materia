defmodule Materia.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Materia.Accounts.User
  alias Materia.Authenticator
  alias Materia.Mails
  alias MateriaUtils.Ecto.EctoUtil

  alias Materia.Errors.BusinessError

  require Logger

  @msg_err_duplicate_emal "this email address was already registered."

  @msg_user_not_active "user not active."

  @doc """
  Returns the list of users.

  ## Examples


  ```

  iex(1)> users = Materia.Accounts.list_users()
  iex(2)> MateriaWeb.UserView.render("index.json", %{users: users})
  [
    %{
      addresses: [],
      back_ground_img_url: nil,
      descriptions: nil,
      email: "fugafuga@example.com",
      external_user_id: nil,
      icon_img_url: nil,
      id: 2,
      lock_version: 1,
      name: "fugafuga",
      organization: nil,
      phone_number: nil,
      role: "operator",
      status: 1
    },
    %{
      addresses: [
        %{
          address1: "福岡市中央区",
          address2: "港 x-x-xx",
          id: 1,
          latitude: nil,
          location: "福岡県",
          lock_version: 0,
          longitude: nil,
          organization: [],
          subject: "living",
          user: [],
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
          organization: [],
          subject: "billing",
          user: [],
          zip_code: "810-ZZZZ"
        }
      ],
      back_ground_img_url: nil,
      descriptions: nil,
      email: "hogehoge@example.com",
      external_user_id: nil,
      icon_img_url: nil,
      id: 1,
      lock_version: 2,
      name: "hogehoge",
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
      phone_number: nil,
      role: "admin",
      status: 1
    }
  ]
  ```

  """
  def list_users do
    repo = Application.get_env(:materia, :repo)

    User
    |> repo.all()
    |> repo.preload([:organization, :addresses])
  end

  @doc """

  User汎用検索

  ```

  iex(1)> users = Materia.Accounts.list_users_by_params(%{"and" => [%{"role" => "admin"}], "or" => [%{"status" => 1}, %{"status" => 2}] })
  iex(2)> MateriaWeb.UserView.render("index.json", %{users: users})
  [
    %{
      addresses: [],
      back_ground_img_url: nil,
      descriptions: nil,
      email: "hogehoge@example.com",
      external_user_id: nil,
      icon_img_url: nil,
      id: 1,
      lock_version: 2,
      name: "hogehoge",
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
      phone_number: nil,
      role: "admin",
      status: 1
    }
  ]
  iex(3)> users = Materia.Accounts.list_users_by_params(%{"and" => [%{"status" => 1}]})
  iex(4)> MateriaWeb.UserView.render("index.json", %{users: users})
  [
    %{
      addresses: [],
      back_ground_img_url: nil,
      descriptions: nil,
      email: "fugafuga@example.com",
      external_user_id: nil,
      icon_img_url: nil,
      id: 2,
      lock_version: 1,
      name: "fugafuga",
      organization: nil,
      phone_number: nil,
      role: "operator",
      status: 1
    },
    %{
      addresses: [],
      back_ground_img_url: nil,
      descriptions: nil,
      email: "hogehoge@example.com",
      external_user_id: nil,
      icon_img_url: nil,
      id: 1,
      lock_version: 2,
      name: "hogehoge",
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
      phone_number: nil,
      role: "admin",
      status: 1
    }
  ]
  ```

  """
  def list_users_by_params(params) do
    repo = Application.get_env(:materia, :repo)

    repo
    |> EctoUtil.select_by_param(User, params)
    |> repo.preload(:organization)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

  ```
  iex(1)> user = Materia.Accounts.get_user!(1)
  iex(2)> MateriaWeb.UserView.render("show.json", %{user: user})
  %{
    addresses: [
      %{
        address1: "福岡市中央区",
        address2: "大名 x-x-xx",
        id: 2,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: [],
        subject: "billing",
        user: [],
        zip_code: "810-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address2: "港 x-x-xx",
        id: 1,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: [],
        subject: "living",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 2,
    name: "hogehoge",
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
    phone_number: nil,
    role: "admin",
    status: 1
  }

  ```

  """
  def get_user!(id) do
    repo = Application.get_env(:materia, :repo)

    User
    |> repo.get!(id)
    |> repo.preload([:organization, :addresses])
  end

  @doc """
  ## Examples

  ```
  iex(1)> user = Materia.Accounts.get_user_by_email("hogehoge@example.com")
  iex(2)> MateriaWeb.UserView.render("show.json", %{user: user})
  %{
  addresses: [],
  back_ground_img_url: nil,
  descriptions: nil,
  email: "hogehoge@example.com",
  external_user_id: nil,
  icon_img_url: nil,
  id: 1,
  lock_version: 2,
  name: "hogehoge",
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
  phone_number: nil,
  role: "admin",
  status: 1
  }
  iex(3)> user = Materia.Accounts.get_user_by_email("not_exist@example.com")
  nil
  ```

  """
  def get_user_by_email(email) do
    repo = Application.get_env(:materia, :repo)

    user =
      with [user] <-
             User
             |> where(email: ^email)
             |> repo.all()
             |> repo.preload(:organization) do
        user
      else
        _ -> nil
      end
  end

  @doc """
  Creates a user.

  ## Examples

  only requred params and full params case

  ```

  iex(1)> {:ok, user} = Materia.Accounts.create_user(%{name: "テスト０１", email: "test01@example.com", password: "test01", role: "operator", organization_id: 1})
  iex(2)> MateriaWeb.UserView.render("show.json", %{user: user}) |> Map.delete(:id)
  %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "test01@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 1,
    name: "テスト０１",
    organization: [],
    phone_number: nil,
    role: "operator",
    status: 1
  }
  iex(3)> {:ok, user} = Materia.Accounts.create_user(%{name: "テスト０２", email: "test02@example.com", password: "test01", role: "operator", back_ground_img_url: "https://test02.com/bg_img.jpg", icon_img_url: "https://test02.com/icon_img.png", descriptions: "説明", phone_number: "090-YYYY-XXXX", status: 1})
  iex(4)> MateriaWeb.UserView.render("show.json", %{user: user}) |> Map.delete(:id)
  %{
    addresses: [],
    back_ground_img_url: "https://test02.com/bg_img.jpg",
    descriptions: "説明",
    email: "test02@example.com",
    external_user_id: nil,
    icon_img_url: "https://test02.com/icon_img.png",
    lock_version: 1,
    name: "テスト０２",
    organization: [],
    role: "operator",
    phone_number: "090-YYYY-XXXX",
    status: 1
  }

  ```

  """
  def create_user(attrs \\ %{}) do
    repo = Application.get_env(:materia, :repo)

    %User{}
    |> User.changeset_create(attrs)
    |> repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

  ```

  iex(1)> user = Materia.Accounts.get_user!(1)
  iex(2)> {:ok, updated_user} = Materia.Accounts.update_user(user, %{name: "更新済みユーザー"})
  iex(3)> MateriaWeb.UserView.render("show.json", %{user: updated_user})
  %{
    addresses: [
      %{
        address1: "福岡市中央区",
        address2: "大名 x-x-xx",
        id: 2,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: [],
        subject: "billing",
        user: [],
        zip_code: "810-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address2: "港 x-x-xx",
        id: 1,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: [],
        subject: "living",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 3,
    name: "更新済みユーザー",
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
    phone_number: nil,
    role: "admin",
    status: 1
  }

  ```

  """
  def update_user(%User{} = user, attrs) do
    repo = Application.get_env(:materia, :repo)

    user
    |> User.changeset_update(attrs)
    |> repo.update()
  end

  @doc """
  Deletes a User.

  Cascade delete on address

  ## Examples

  ```

  iex(1)> user = Materia.Accounts.get_user!(1)
  iex(2)> Materia.Accounts.delete_user(user)
  iex(3)> users = Materia.Accounts.list_users()
  iex(4)> MateriaWeb.UserView.render("index.json", %{users: users})
  [
    %{
      addresses: [],
      back_ground_img_url: nil,
      descriptions: nil,
      email: "fugafuga@example.com",
      external_user_id: nil,
      icon_img_url: nil,
      id: 2,
      lock_version: 1,
      name: "fugafuga",
      organization: nil,
      role: "operator",
      phone_number: nil,
      status: 1
    }
  ]

  ```


  """
  def delete_user(%User{} = user) do
    repo = Application.get_env(:materia, :repo)
    repo.delete(user)
  end

  alias Materia.Accounts.Grant

  @doc """
  Returns the list of grants.

  ## Examples

  ```

  iex(1)> grants = Materia.Accounts.list_grants()
  iex(2)> MateriaWeb.GrantView.render("index.json", %{grants: grants}) |> Enum.chunk_every(2) |> List.first()
  [
    %{
      id: 1,
      method: "ANY",
      request_path: "/api/ops/users",
      role: "anybody"
    },
    %{
      id: 2,
      method: "ANY",
      request_path: "/api/ops/grants",
      role: "admin"
    }
  ]

  ```

  """
  def list_grants do
    repo = Application.get_env(:materia, :repo)
    repo.all(Grant)
  end

  @doc """
  Gets a single grant.

  Raises `Ecto.NoResultsError` if the Grant does not exist.

  ## Examples

  ```

  iex(1)> grant = Materia.Accounts.get_grant!(1)
  iex(2)> MateriaWeb.GrantView.render("show.json", %{grant: grant})
  %{id: 1, method: "ANY", request_path: "/api/ops/users", role: "anybody"}

  ```

  """
  def get_grant!(id) do
    repo = Application.get_env(:materia, :repo)
    repo.get!(Grant, id)
  end

  @doc """
  指定されらロールで実行可能な権限の一覧を返す。

  結果の権限リストにはrole "anybody"で登録された権限も含む。

  ## Examples

  ```

  iex(1)> grants = Materia.Accounts.get_grant_by_role("admin")
  iex(2)> MateriaWeb.GrantView.render("index.json", %{grants: grants}) |> Enum.chunk_every(2) |> List.first()
  [
    %{
      id: 1,
      method: "ANY",
      request_path: "/api/ops/users",
      role: "anybody"
    },
    %{
      id: 2,
      method: "ANY",
      request_path: "/api/ops/grants",
      role: "admin"
    }
  ]

  ```

  """
  def get_grant_by_role(role) do
    repo = Application.get_env(:materia, :repo)
    dc_role = String.downcase(role)

    Grant
    |> where([g], g.role == ^dc_role or g.role == ^Grant.role().anybody)
    |> repo.all()
  end

  @doc """
  Creates a grant.

  ## Examples

  ```

  iex(1)> {:ok, grant} = Materia.Accounts.create_grant(%{role: "test_user", method: "GET", request_path: "/hogehoge"})
  iex(2)> MateriaWeb.GrantView.render("show.json", %{grant: grant}) |> Map.delete(:id)
  %{method: "GET", request_path: "/hogehoge", role: "test_user"}

  ```

  """
  def create_grant(attrs \\ %{}) do
    repo = Application.get_env(:materia, :repo)

    %Grant{}
    |> Grant.changeset(attrs)
    |> repo.insert()
  end

  @doc """
  Updates a grant.

  ## Examples

  ```

  iex(1)> grant = Materia.Accounts.get_grant!(1)
  iex(2)> {:ok, updated_grant} = Materia.Accounts.update_grant(grant, %{request_path: "/hogehoge"})
  iex(3)> MateriaWeb.GrantView.render("show.json", %{grant: updated_grant})
  %{id: 1, method: "ANY", request_path: "/hogehoge", role: "anybody"}

  ```


  """
  def update_grant(%Grant{} = grant, attrs) do
    repo = Application.get_env(:materia, :repo)

    grant
    |> Grant.changeset(attrs)
    |> repo.update()
  end

  @doc """
  Deletes a Grant.

  ## Examples

  ```

  iex(1)> grant = Materia.Accounts.get_grant!(1)
  iex(2)> {:ok, deleted_grant} = Materia.Accounts.delete_grant(grant)
  iex(3)> grants = Materia.Accounts.list_grants()
  iex(4)> MateriaWeb.GrantView.render("index.json", %{grants: grants}) |> Enum.chunk_every(2) |> List.first()
  [
    %{
      id: 2,
      method: "ANY",
      request_path: "/api/ops/grants",
      role: "admin"
    },
    %{
      id: 3,
      method: "GET",
      request_path: "/api/ops/grants",
      role: "operator"
    }
  ]
  ```

  """
  def delete_grant(%Grant{} = grant) do
    repo = Application.get_env(:materia, :repo)
    repo.delete(grant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking grant changes.

  ## Examples

  ```

  iex(1)> Materia.Accounts.change_grant(%Materia.Accounts.Grant{role: "admin", method: "GET", request_path: "/hogehoge"})
  #Ecto.Changeset<action: nil, changes: %{}, errors: [], data: #Materia.Accounts.Grant<>, valid?: true>

  ```

  """
  def change_grant(%Grant{} = grant) do
    Grant.changeset(grant, %{})
  end

  @doc false
  defp create_tmp_user(attrs \\ %{}) do
    repo = Application.get_env(:materia, :repo)

    %User{}
    |> User.changeset_tmp_registration(attrs)
    |> repo.insert()
  end

  @doc """
  ユーザー仮登録

  ログイン不可能なユーザー情報を仮登録する。

  ## Examples

  ```
  iex(1)> {:ok, tmp_user} = Materia.Accounts.regster_tmp_user(%{}, "test001@example.com", "operator")
  iex(2)> MateriaWeb.UserView.render("show.json", %{user: tmp_user.user}) |> Map.delete(:id)
  %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "test001@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 1,
    name: nil,
    organization: [],
    phone_number: nil,
    role: "operator",
    status: 0
  }
  iex(3)> tmp_user.user_registration_token != nil
  true
  """
  def regster_tmp_user(_result, email, role) do
    config = Application.get_env(:materia, Materia.Accounts)

    user = get_user_by_email(email)

    merged_user =
      if user == nil do
        {:ok, created_user} = create_tmp_user(%{email: email, role: role})
        created_user
      else
        if user.status != User.status().unactivated do
          raise BusinessError, message: @msg_err_duplicate_emal
        else
          {:ok, updated_user} = update_user(user, %{role: role})
          updated_user
        end
      end

    {:ok, user_registration_token} = Authenticator.get_user_registration_token(email)

    email = merged_user.email
    template_type = config[:user_registration_request_mail_template_type]
    from_email = config[:system_from_email]
    from_name = config[:system_from_name]
    user_registration_url = config[:user_registration_url]

    # 認証メール送信
    replace_list = [
      {"{!email}", email},
      {"{!user_registration_url}", user_registration_url},
      {"!{user_regstration_token}", user_registration_token}
    ]

    if template_type != nil do
      send_email(template_type, from_email, email, replace_list, from_name)
    end

    result = %{user: merged_user, user_registration_token: user_registration_token}
    {:ok, result}
  end

  @doc false
  defp registration_user(%User{} = user, attrs) do
    repo = Application.get_env(:materia, :repo)
    user
    |> User.changeset_registration(attrs)
    |> repo.update()
  end

  @doc """
  Ecto.Mulit用ユーザー更新

  ```

  iex(1)> user = Materia.Accounts.get_user!(1)
  iex(13)> {:ok, updated_user} = Materia.Accounts.update_user(%{}, user, %{name: "updated user"})
  iex(15)> MateriaWeb.UserView.render("show.json", %{user: updated_user})
  %{
    addresses: [
      %{
        address1: "福岡市中央区",
        address2: "大名 x-x-xx",
        id: 2,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: [],
        subject: "billing",
        user: [],
        zip_code: "810-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address2: "港 x-x-xx",
        id: 1,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: [],
        subject: "living",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    id: 1,
    lock_version: 3,
    name: "updated user",
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
    phone_number: nil,
    role: "admin",
    status: 1
  }

  ```

  """
  def update_user(_result, user, attr) do
    update_user(user, attr)
  end

  @doc """
  ユーザー本登録

  仮登録ユーザー情報を更新しログイン可能な本登録ユーザー情報にする。

  ## Examples

  ```
  iex(1)> {:ok, tmp_user} = Materia.Accounts.regster_tmp_user(%{}, "test002@example.com", "operator")
  iex(2)> {:ok, user} = Materia.Accounts.registration_user(%{}, tmp_user.user, %{name: "test002 user", password: "password"})
  iex(3)> MateriaWeb.UserView.render("show.json", %{user: user}) |> Map.delete(:id)
  %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "test002@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "test002 user",
    organization: [],
    phone_number: nil,
    role: "operator",
    status: 1
  }
  """
  def registration_user(_result, user, attr) do
    config = Application.get_env(:materia, Materia.Accounts)

    #仮登録ユーザーでなければエラー
    if user.status != User.status.unactivated do
      raise BusinessError, message: @msg_err_duplicate_emal
    end

    {:ok, user} = registration_user(user, attr)

    email = user.email
    template_type = config[:user_registration_completed_mail_template_type]
    from_email = config[:system_from_email]
    from_name = config[:system_from_name]
    sign_in_url = config[:sign_in_url]

    # 完了メール送信
    replace_list = [
      {"{!name}", user.name},
      {"{!email}", user.email},
      {"{!sign_in_url}", sign_in_url}
    ]

    if template_type != nil do
      send_email(template_type, from_email, email, replace_list, from_name)
    end

    {:ok, user}
  end

  @doc """
  ユーザー本登録＆サインイン

  仮登録ユーザー情報を更新しログイン可能な本登録ユーザー情報に更新し、同時にログイン処理を行う。

  ## Examples

  ```
  iex(1)> {:ok, tmp_user} = Materia.Accounts.regster_tmp_user(%{}, "test003@example.com", "operator")
  iex(2)> {:ok, user_token} = Materia.Accounts.registration_user_and_sign_in(%{}, tmp_user.user, %{name: "test003 user", password: "password"})
  iex(3)> MateriaWeb.UserView.render("show.json", %{user: user_token.user}) |> Map.delete(:id)
  %{
    addresses: [],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "test003@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 2,
    name: "test003 user",
    organization: [],
    phone_number: nil,
    role: "operator",
    status: 1
  }
  iex(4)> user_token.access_token != nil
  true
  iex(5)> user_token.refresh_token != nil
  true
  """
  def registration_user_and_sign_in(_result, user, attr) do

    {:ok, user} = registration_user(_result, user, attr)

    {:ok, result} = Authenticator.sign_in(user.email, user.password)

    user_with_token = %{
      user: user,
      access_token: result.access_token,
      refresh_token: result.refresh_token,
    }
    Map.merge(user, result)

    {:ok, user_with_token}

  end

  @doc """
  パスワードリセット要求

  パスワードリセット用のトークン発酵を行う。

  ## Examples

  ```
  iex(1)> {:ok, token} = Materia.Accounts.request_password_reset(%{}, "hogehoge@example.com")
  iex(2)> token.password_reset_token != nil
  true
  """
  def request_password_reset(_result, email) do
    config = Application.get_env(:materia, Materia.Accounts)

    # ユーザーの存在チェック
    user = get_user_by_email(email)
    if user == nil do
      # ユーザーが存在しない場合も素知らぬ顔で正常終了する
      {:ok, %{password_reset_token: ""}}
    else
      {:ok, password_reset_token} = Authenticator.get_password_reset_token(email)

      email = email
      template_type = config[:password_reset_request_mail_template_type]
      from_email = config[:system_from_email]
      from_name = config[:system_from_name]
      password_reset_url = config[:password_reset_url]

      # 認証メール送信
      replace_list = [
        {"{!email}", email},
        {"{!password_reset_url}", password_reset_url},
        {"!{password_reset_token}", password_reset_token}
      ]

      if template_type != nil do
        send_email(template_type, from_email, email, replace_list, from_name)
      end

      {:ok, %{password_reset_token: password_reset_token}}

    end

  end

  @doc """
  パスワードリセット

  パスワードリセットを行う。

  ## Examples

  ```
  iex(1)> user = Materia.Accounts.get_user!(1)
  iex(2)> {:ok, updated_user} = Materia.Accounts.reset_my_password(%{}, user, "password2")
  iex(3)> MateriaWeb.UserView.render("show.json", %{user: updated_user}) |> Map.delete(:id)
  %{
    addresses: [
      %{
        address1: "福岡市中央区",
        address2: "大名 x-x-xx",
        id: 2,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: [],
        subject: "billing",
        user: [],
        zip_code: "810-ZZZZ"
      },
      %{
        address1: "福岡市中央区",
        address2: "港 x-x-xx",
        id: 1,
        latitude: nil,
        location: "福岡県",
        lock_version: 0,
        longitude: nil,
        organization: [],
        subject: "living",
        user: [],
        zip_code: "810-ZZZZ"
      }
    ],
    back_ground_img_url: nil,
    descriptions: nil,
    email: "hogehoge@example.com",
    external_user_id: nil,
    icon_img_url: nil,
    lock_version: 3,
    name: "hogehoge",
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
    phone_number: nil,
    role: "admin",
    status: 1
  }
  """
  def reset_my_password(_result, user, password) do
    config = Application.get_env(:materia, Materia.Accounts)

    if user.status != User.status().activated do
      raise BusinessError, message: @msg_user_not_active
    end

    {:ok, user} = update_user(user, %{password: password})

    email = user.email
    template_type = config[:password_reset_completed_mail_template_type]
    from_email = config[:system_from_email]
    from_name = config[:system_from_name]
    sign_in_url = config[:sign_in_url]

    # 完了メール送信
    replace_list = [
      {"{!name}", user.name},
      {"{!email}", user.email},
      {"{!sign_in_url}", sign_in_url}
    ]

    if template_type != nil do
      send_email(template_type, from_email, email, replace_list, from_name)
    end

    {:ok, user}

  end

  @doc false
  defp send_email(template_type, from_email, email, replace_list, from_name \\ nil) do
    if from_email == nil do
      raise BusinessError,
        message: "config :materia, Materia.Accounts, system_from_email not found."
    end

    template = Mails.get_mail_template_by_mail_template_type(template_type)

    if template == [] do
      raise BusinessError, message: "mail_template not found. template_type: #{template_type}"
    end

    with {:ok, message} <-
           Mails.send_mail(from_email, email, template.subject, template.body, replace_list, from_name) do
      Logger.debug(
        "#{__MODULE__} registration_user. send mail success. message:#{inspect(message)}"
      )
    else
      {:error, reason} ->
        Logger.debug(
          "#{__MODULE__} registration_user. send mail error. reason:#{inspect(reason)}"
        )
        raise BusinessError, message: "send user registration mail error."
    end
  end


end