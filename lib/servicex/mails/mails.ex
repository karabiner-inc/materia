defmodule Servicex.Mails do
  @moduledoc """
  The Mails context.
  """

  import Ecto.Query, warn: false

  alias Servicex.Mails.Template

  @doc """
  Returns the list of templates.

  ## Examples

      iex> list_templates()
      [%Template{}, ...]

  """
  def list_templates do
    repo = Application.get_env(:servicex, :repo)
    repo.all(Template)
  end

  @doc """
  Gets a single template.

  Raises `Ecto.NoResultsError` if the Template does not exist.

  ## Examples

      iex> get_template!(123)
      %Template{}

      iex> get_template!(456)
      ** (Ecto.NoResultsError)

  """
  def get_template!(id) do
    repo = Application.get_env(:servicex, :repo)
    repo.get!(Template, id)
  end

  @doc """
  Creates a template.

  ## Examples

      iex> create_template(%{field: value})
      {:ok, %Template{}}

      iex> create_template(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_template(attrs \\ %{}) do
    repo = Application.get_env(:servicex, :repo)
    %Template{}
    |> Template.changeset_create(attrs)
    |> repo.insert()
  end

  @doc """
  Updates a template.

  ## Examples

      iex> update_template(template, %{field: new_value})
      {:ok, %Template{}}

      iex> update_template(template, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_template(%Template{} = template, attrs) do
    repo = Application.get_env(:servicex, :repo)
    template
    |> Template.changeset_update(attrs)
    |> repo.update()
  end

  @doc """
  Deletes a Template.

  ## Examples

      iex> delete_template(template)
      {:ok, %Template{}}

      iex> delete_template(template)
      {:error, %Ecto.Changeset{}}

  """
  def delete_template(%Template{} = template) do
    repo = Application.get_env(:servicex, :repo)
    repo.delete(template)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking template changes.

  ## Examples

      iex> change_template(template)
      %Ecto.Changeset{source: %Template{}}

  """
  #def change_template(%Template{} = template) do
  #  Template.changeset(template, %{})
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

    {:ok, result} = Servicex.MailClient.send_mail(from_email, to_email, replaced_subject, replaced_body_text)

  end
end
