defmodule Servicex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Servicex.Accounts.User
  alias Servicex.Authenticator
  alias Servicex.Mails
  alias ServicexUtils.Ecto.EctoUtil

  alias Servicex.Errors.ServicexError

  require Logger

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users do
    repo = Application.get_env(:servicex, :repo)
    repo.all(User)
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """

  def get_user!(id) do
    repo = Application.get_env(:servicex, :repo)
    repo.get!(User, id)
  end

  def get_user_by_email!(email) do
    repo = Application.get_env(:servicex, :repo)
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

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    repo = Application.get_env(:servicex, :repo)
    %User{}
    |> User.changeset_create(attrs)
    |> repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    repo = Application.get_env(:servicex, :repo)
    user
    |> User.changeset_update(attrs)
    |> repo.update()
  end

  @doc """
  Deletes a User.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    repo = Application.get_env(:servicex, :repo)
    repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  #def change_user(%User{} = user) do
  #  User.changeset(user, %{})
  #end

  alias Servicex.Accounts.Grant

  @doc """
  Returns the list of grants.

  ## Examples

      iex> list_grants()
      [%Grant{}, ...]

  """
  def list_grants do
    repo = Application.get_env(:servicex, :repo)
    repo.all(Grant)
  end

  @doc """
  Gets a single grant.

  Raises `Ecto.NoResultsError` if the Grant does not exist.

  ## Examples

      iex> get_grant!(123)
      %Grant{}

      iex> get_grant!(456)
      ** (Ecto.NoResultsError)

  """
  def get_grant!(id) do
    repo = Application.get_env(:servicex, :repo)
    repo.get!(Grant, id)
  end

  def get_grant_by_role(role) do
    repo = Application.get_env(:servicex, :repo)
    dc_role = String.downcase(role)
    Grant
    |> where([g], g.role == ^dc_role or g.role == ^Grant.role.anybody)
    |> repo.all()
  end

  @doc """
  Creates a grant.

  ## Examples

      iex> create_grant(%{field: value})
      {:ok, %Grant{}}

      iex> create_grant(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_grant(attrs \\ %{}) do
    repo = Application.get_env(:servicex, :repo)
    %Grant{}
    |> Grant.changeset(attrs)
    |> repo.insert()
  end

  @doc """
  Updates a grant.

  ## Examples

      iex> update_grant(grant, %{field: new_value})
      {:ok, %Grant{}}

      iex> update_grant(grant, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_grant(%Grant{} = grant, attrs) do
    repo = Application.get_env(:servicex, :repo)
    grant
    |> Grant.changeset(attrs)
    |> repo.update()
  end

  @doc """
  Deletes a Grant.

  ## Examples

      iex> delete_grant(grant)
      {:ok, %Grant{}}

      iex> delete_grant(grant)
      {:error, %Ecto.Changeset{}}

  """
  def delete_grant(%Grant{} = grant) do
    repo = Application.get_env(:servicex, :repo)
    repo.delete(grant)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking grant changes.

  ## Examples

      iex> change_grant(grant)
      %Ecto.Changeset{source: %Grant{}}

  """
  def change_grant(%Grant{} = grant) do
    Grant.changeset(grant, %{})
  end

  def send_verify_mail(%User{} = user) do

    from = Application.get_env(:servicex, Servicex.Accounts)[:verify_mail_from_address]
    subject = Application.get_env(:servicex, Servicex.Accounts)[:verify_mail_subject]
    mail_template = Application.get_env(:servicex, Servicex.Accounts)[:verify_mail_template]
    verify_url = Application.get_env(:servicex, Servicex.Accounts)[:verify_url]

    # verify mail template
    # place holders
    #  @user_name@  display user name.
    #  @verify_url@  service verify page url. replace that "{verify_url}?verify_key={verify_key}"

    body_text = mail_template
    |> String.replace("@user_name@", user.name)
    |> String.replace("@verify_url@", verify_url)

    {:ok, result} = Servicex.MailClient.send_mail(from, user.email, subject, body_text)

  end

  def create_tmp_user(attrs \\ %{}) do
    repo = Application.get_env(:servicex, :repo)
    %User{}
    |> User.changeset_tmp_registration(attrs)
    |> repo.insert()
  end

  def regster_tmp_user(_result, email, role) do

    config = Application.get_env(:servicex, Servicex.Accounts)

    user = get_user_by_email!(email)

    merged_user =
    if user == nil do
      {:ok, created_user} = create_tmp_user(%{email: email, role: role})
      created_user
    else
      if user.status != User.status.unactivated do
        raise ServicexError, message: "this email address was already registered."
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
        raise ServicexError, message: "config :servicex, Servicex.Accounts, system_from_email not found."
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
          raise ServicexError, message: "send tmp registration mail error."
      end

    end

    result = %{user: merged_user, user_registration_token: user_registration_token}
    {:ok, result }

  end

  def registration_user(%User{} = user, attrs) do
    repo = Application.get_env(:servicex, :repo)
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
    config = Application.get_env(:servicex, Servicex.Accounts)

    {:ok, user} = registration_user(user, attr)

    email = user.email
    template_id =config[:registered_mail_template_id]
    from_email = config[:system_from_email]
    sign_in_url = config[:sign_in_url]
    if template_id != nil do

      if from_email == nil do
        raise ServicexError, message: "config :servicex, Servicex.Accounts, system_from_email not found."
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
          raise ServicexError, message: "send user registration mail error."
      end
    end
    {:ok, user}
  end

  def list_user_by_params(params) do
    repo = Application.get_env(:servicex, :repo)
    EctoUtil.select_by_param(repo, User, params)
  end


  alias Servicex.Accounts.Address

  @doc """
  Returns the list of addresses.

  ## Examples

      iex> list_addresses()
      [%Address{}, ...]

  """
  def list_addresses do
    repo = Application.get_env(:servicex, :repo)
    repo.all(Address)
  end

  @doc """
  Returns the list of my addresses.

  ## Examples

      iex> list_my_addresses()
      [%Address{}, ...]

  """
  def list_my_addresses(user_id) do
    repo = Application.get_env(:servicex, :repo)
    query = from a in Address, where: a.user_id == ^user_id, order_by: [desc: a.inserted_at], select: a
    repo.all(query)
  end

  @doc """
  Gets a single address.

  Raises `Ecto.NoResultsError` if the Address does not exist.

  ## Examples

      iex> get_address!(123)
      %Address{}

      iex> get_address!(456)
      ** (Ecto.NoResultsError)

  """
  def get_address!(id) do
    repo = Application.get_env(:servicex, :repo)
    repo.get!(Address, id)
  end
  @doc """
  Creates a address.

  ## Examples

      iex> create_address(%{field: value})
      {:ok, %Address{}}

      iex> create_address(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_address(attrs \\ %{}) do
    repo = Application.get_env(:servicex, :repo)
    %Address{}
    |> Address.changeset(attrs)
    |> repo.insert()
  end

  @doc """
  Updates a address.

  ## Examples

      iex> update_address(address, %{field: new_value})
      {:ok, %Address{}}

      iex> update_address(address, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_address(%Address{} = address, attrs) do
    repo = Application.get_env(:servicex, :repo)
    address
    |> Address.changeset(attrs)
    |> repo.update()
  end

  @doc """
  Deletes a Address.

  ## Examples

      iex> delete_address(address)
      {:ok, %Address{}}

      iex> delete_address(address)
      {:error, %Ecto.Changeset{}}

  """
  def delete_address(%Address{} = address) do
    repo = Application.get_env(:servicex, :repo)
    repo.delete(address)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking address changes.

  ## Examples

      iex> change_address(address)
      %Ecto.Changeset{source: %Address{}}

  """
  def change_address(%Address{} = address) do
    Address.changeset(address, %{})
  end
end
