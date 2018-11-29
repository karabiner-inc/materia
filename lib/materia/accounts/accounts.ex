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

  @doc """
  Returns the list of users.

  ## Examples


  ```

  iex(1)>  users = Materia.Accounts.list_users()
  iex(2)>  MateriaWeb.UserView.render("index.json", %{users: users})
  [
             %{
               email: "hogehoge@example.com",
               id: 1,
               lock_version: 1,
               name: "hogehoge",
               role: "admin",
               status: 1
             },
             %{
               email: "fugafuga@example.com",
               id: 2,
               lock_version: 1,
               name: "fugafuga",
               role: "operator",
               status: 1
             }
           ]
  ```

  """
  def list_users do
    repo = Application.get_env(:materia, :repo)
    repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

  ```
  iex(1)> user = Materia.Accounts.get_user!(1)
  iex(2)> MateriaWeb.UserView.render("show.json", %{user: user})
  %{
    email: "hogehoge@example.com",
    id: 1,
    lock_version: 1,
    name: "hogehoge",
    role: "admin",
    status: 1
  }

  ```


  """
  def get_user!(id) do
    repo = Application.get_env(:materia, :repo)
    repo.get!(User, id)
  end

  @doc """
  ## Examples

  ```
  iex(1)> user = Materia.Accounts.get_user_by_email("hogehoge@example.com")
  iex(2)> MateriaWeb.UserView.render("show.json", %{user: user})
  %{
    email: "hogehoge@example.com",
    id: 1,
    lock_version: 1,
    name: "hogehoge",
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
    with [user] <-  User
    |> where(email: ^email)
    |> repo.all()
    do
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

  iex(1)> {:ok, user} = Materia.Accounts.create_user(%{name: "テスト０１", email: "test01@example.com", password: "test01", role: "operator"})
  iex(2)> MateriaWeb.UserView.render("show.json", %{user: user})
  %{
    email: "test01@example.com",
    id: 3,
    lock_version: 1,
    name: "テスト０１",
    role: "operator",
    status: 1
  }
  iex(3)> {:ok, user} = Materia.Accounts.create_user(%{name: "テスト０２", email: "test02@example.com", password: "test01", role: "operator", status: 1})
  iex(4)> MateriaWeb.UserView.render("show.json", %{user: user})
  %{
    email: "test02@example.com",
    id: 4,
    lock_version: 1,
    name: "テスト０２",
    role: "operator",
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
    email: "hogehoge@example.com",
    id: 1,
    lock_version: 2,
    name: "更新済みユーザー",
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

  ## Examples

  ```

  iex(1)> user = Materia.Accounts.get_user!(1)
  iex(2)> Materia.Accounts.delete_user(user)
  iex(3)> users = Materia.Accounts.list_users()
  iex(4)> MateriaWeb.UserView.render("index.json", %{users: users})
  [
    %{
      email: "fugafuga@example.com",
      id: 2,
      lock_version: 1,
      name: "fugafuga",
      role: "operator",
      status: 1
    }
  ]

  ```


  """
  def delete_user(%User{} = user) do
    repo = Application.get_env(:materia, :repo)
    repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples



  """
  #def change_user(%User{} = user) do
  #  User.changeset(user, %{})
  #end

  alias Materia.Accounts.Grant

  @doc """
  Returns the list of grants.

  ## Examples

  ```

  iex(1)> grants = Materia.Accounts.list_grants()
  iex(2)> MateriaWeb.GrantView.render("index.json", %{grants: grants})
  [
    %{id: 1, method: "ANY", request_path: "/api/ops/users", role: "anybody"},
    %{id: 2, method: "ANY", request_path: "/api/ops/grants", role: "admin"},
    %{id: 3, method: "GET", request_path: "/api/ops/grants", role: "operator"}
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
  iex(2)> MateriaWeb.GrantView.render("index.json", %{grants: grants})
  [
    %{id: 1, method: "ANY", request_path: "/api/ops/users", role: "anybody"},
    %{id: 2, method: "ANY", request_path: "/api/ops/grants", role: "admin"},
  ]

  ```

  """
  def get_grant_by_role(role) do
    repo = Application.get_env(:materia, :repo)
    dc_role = String.downcase(role)
    Grant
    |> where([g], g.role == ^dc_role or g.role == ^Grant.role.anybody)
    |> repo.all()
  end

  @doc """
  Creates a grant.

  ## Examples

  ```

  iex(1)> {:ok, grant} = Materia.Accounts.create_grant(%{role: "test_user", method: "GET", request_path: "/hogehoge"})
  iex(2)> MateriaWeb.GrantView.render("show.json", %{grant: grant})
  %{id: 4, method: "GET", request_path: "/hogehoge", role: "test_user"}

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
  iex(4)> MateriaWeb.GrantView.render("index.json", %{grants: grants})
  [
    %{id: 2, method: "ANY", request_path: "/api/ops/grants", role: "admin"},
    %{id: 3, method: "GET", request_path: "/api/ops/grants", role: "operator"},
    %{id: 4, method: "GET", request_path: "/hogehoge", role: "test_user"}
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
  #Ecto.Changeset<action: nil, changes: %{}, errors: [],
   data: #Materia.Accounts.Grant<>, valid?: true>

  ```

  """
  def change_grant(%Grant{} = grant) do
    Grant.changeset(grant, %{})
  end

  def send_verify_mail(%User{} = user) do

    from = Application.get_env(:materia, Materia.Accounts)[:verify_mail_from_address]
    subject = Application.get_env(:materia, Materia.Accounts)[:verify_mail_subject]
    mail_template = Application.get_env(:materia, Materia.Accounts)[:verify_mail_template]
    verify_url = Application.get_env(:materia, Materia.Accounts)[:verify_url]

    # verify mail template
    # place holders
    #  @user_name@  display user name.
    #  @verify_url@  service verify page url. replace that "{verify_url}?verify_key={verify_key}"

    body_text = mail_template
    |> String.replace("@user_name@", user.name)
    |> String.replace("@verify_url@", verify_url)

    {:ok, result} = Materia.MailClient.send_mail(from, user.email, subject, body_text)

  end

  def create_tmp_user(attrs \\ %{}) do
    repo = Application.get_env(:materia, :repo)
    %User{}
    |> User.changeset_tmp_registration(attrs)
    |> repo.insert()
  end

  def regster_tmp_user(_result, email, role) do

    config = Application.get_env(:materia, Materia.Accounts)

    user = get_user_by_email(email)

    merged_user =
    if user == nil do
      {:ok, created_user} = create_tmp_user(%{email: email, role: role})
      created_user
    else
      if user.status != User.status.unactivated do
        raise BusinessError, message: "this email address was already registered."
      else
        {:ok, updated_user} = update_user(user, %{role: role})
        updated_user
      end
    end

    {:ok, user_registration_token} = Authenticator.get_user_registration_token(email)

    email = merged_user.email
    template_id =config[:verify_mail_template_id]
    from_email = config[:system_from_email]
    user_registration_url = config[:user_registration_url]
    if template_id != nil do

      if from_email == nil do
        raise BusinessError, message: "config :materia, Materia.Accounts, system_from_email not found."
      end

      #認証メール送信
      replace_list = [
        {"{!email}", email},
        {"{!user_registration_url}", user_registration_url},
        {"!{user_regstration_token}", user_registration_token},
      ]
      template = Mails.get_template!(template_id)
      with {:ok, message} <- Mails.send_mail(from_email, email, template.subject, template.body, replace_list) do
        Logger.debug("#{__MODULE__} regster_tmp_user. send mail success. message:#{inspect(message)}")
      else
        {:error, reason} ->
          Logger.debug("#{__MODULE__} regster_tmp_user. send mail error. reason:#{inspect(reason)}")
          raise BusinessError, message: "send tmp registration mail error."
      end

    end

    result = %{user: merged_user, user_registration_token: user_registration_token}
    {:ok, result }

  end

  def registration_user(%User{} = user, attrs) do
    repo = Application.get_env(:materia, :repo)
    user
    |> User.changeset_registration(attrs)
    |> repo.update()
  end


  @doc false
  # Ecto.Mulit用
  def update_user(_result, user, attr) do
    update_user(user, attr)
  end

  def registration_user(_result, user, attr) do
    config = Application.get_env(:materia, Materia.Accounts)

    {:ok, user} = registration_user(user, attr)

    email = user.email
    template_id =config[:registered_mail_template_id]
    from_email = config[:system_from_email]
    sign_in_url = config[:sign_in_url]
    if template_id != nil do

      if from_email == nil do
        raise BusinessError, message: "config :materia, Materia.Accounts, system_from_email not found."
      end

      #認証メール送信
      replace_list = [
        {"{!name}", user.name},
        {"{!email}", user.email},
        {"{!sign_in_url}", sign_in_url},
      ]
      template = Mails.get_template!(template_id)
      with {:ok, message} <- Mails.send_mail(from_email, email, template.subject, template.body, replace_list) do
        Logger.debug("#{__MODULE__} registration_user. send mail success. message:#{inspect(message)}")
      else
        {:error, reason} ->
          Logger.debug("#{__MODULE__} registration_user. send mail error. reason:#{inspect(reason)}")
          raise BusinessError, message: "send user registration mail error."
      end
    end
    {:ok, user}
  end

  @doc """


  """
  def list_user_by_params(params) do
    repo = Application.get_env(:materia, :repo)
    EctoUtil.select_by_param(repo, User, params)
  end


  alias Materia.Accounts.Address

  @doc """
  Returns the list of addresses.


  """
  def list_addresses do
    repo = Application.get_env(:materia, :repo)
    repo.all(Address)
  end

  @doc """
  Returns the list of my addresses.


  """
  def list_my_addresses(user_id) do
    repo = Application.get_env(:materia, :repo)
    query = from a in Address, where: a.user_id == ^user_id, order_by: [desc: a.inserted_at], select: a
    repo.all(query)
  end

  @doc """
  Gets a single address.

  Raises `Ecto.NoResultsError` if the Address does not exist.


  """
  def get_address!(id) do
    repo = Application.get_env(:materia, :repo)
    repo.get!(Address, id)
  end
  @doc """
  Creates a address.

  ## Examples


  """
  def create_address(attrs \\ %{}) do
    repo = Application.get_env(:materia, :repo)
    %Address{}
    |> Address.changeset(attrs)
    |> repo.insert()
  end

  @doc """
  Updates a address.

  ## Examples


  """
  def update_address(%Address{} = address, attrs) do
    repo = Application.get_env(:materia, :repo)
    address
    |> Address.changeset(attrs)
    |> repo.update()
  end

  @doc """
  Deletes a Address.

  ## Examples


  """
  def delete_address(%Address{} = address) do
    repo = Application.get_env(:materia, :repo)
    repo.delete(address)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address changes.


  """
  def change_address(%Address{} = address) do
    Address.changeset(address, %{})
  end
end
