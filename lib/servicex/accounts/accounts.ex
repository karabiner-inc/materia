defmodule Servicex.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false

  alias Servicex.Accounts.User

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
    |> User.changeset(attrs)
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
    |> User.changeset(attrs)
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
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

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
    |> where([g], g.role == ^role or g.dc_role == ^Grant.role.anybody)
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

end
