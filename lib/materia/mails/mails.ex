defmodule Materia.Mails do
  @moduledoc """
  The Mails context.
  """

  import Ecto.Query, warn: false

  alias Materia.Mails.MailTemplate

  @doc """
  Returns the list of mail_templates.

  ## Examples

      iex> list_mail_templates()
      [%MailTemplate{}, ...]

  """
  def list_mail_templates do
    repo = Application.get_env(:materia, :repo)
    repo.all(MailTemplate)
  end

  @doc """
  Gets a single mail_template.

  Raises `Ecto.NoResultsError` if the MailTemplate does not exist.

  ## Examples

      iex> get_mail_template!(123)
      %MailTemplate{}

      iex> get_mail_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_mail_template!(id) do
    repo = Application.get_env(:materia, :repo)
    repo.get!(MailTemplate, id)
  end

  @doc """
  Creates a mail_template.

  ## Examples

      iex> create_mail_template(%{field: value})
      {:ok, %MailTemplate{}}

      iex> create_mail_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_mail_template(attrs \\ %{}) do
    repo = Application.get_env(:materia, :repo)
    %MailTemplate{}
    |> MailTemplate.changeset_create(attrs)
    |> repo.insert()
  end

  @doc """
  Updates a mail_template.

  ## Examples

      iex> update_mail_template(mail_template, %{field: new_value})
      {:ok, %Template{}}

      iex> update_mail_template(mail_template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_mail_template(%MailTemplate{} = mail_template, attrs) do
    repo = Application.get_env(:materia, :repo)
    mail_template
    |> MailTemplate.changeset_update(attrs)
    |> repo.update()
  end

  @doc """
  Deletes a MailTemplate.

  ## Examples

      iex> delete_mail_template(mail_template)
      {:ok, %MailTemplate{}}

      iex> delete_mail_template(mail_template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_mail_template(%MailTemplate{} = mail_template) do
    repo = Application.get_env(:materia, :repo)
    repo.delete(mail_template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking mail_template changes.

  ## Examples

      iex> change_mail_template(mail_template)
      %Ecto.Changeset{source: %MailTemplate{}}

  """
  #def change_mail_template(%MailTemplate{} = mail_template) do
  #  MailTemplate.changeset(mail_template, %{})
  #end

  def send_mail(from_email, to_email, subject, body, replace_list) do
    replaced_subject = replace_list
    |> Enum.reduce(subject, fn(replace_kv, replaced_acc) ->
      {place_holder, value} = replace_kv
      String.replace(replaced_acc, place_holder, value)
    end)

    replaced_body_text = replace_list
    |> Enum.reduce(body, fn(replace_kv, replaced_acc) ->
      {place_holder, value} = replace_kv
      String.replace(replaced_acc, place_holder, value)
    end)

    {:ok, result} = Materia.MailClient.send_mail(from_email, to_email, replaced_subject, replaced_body_text)

  end
end
