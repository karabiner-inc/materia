defmodule Materia.Logs do
  @moduledoc """
  The Logs context.
  """

  import Ecto.Query, warn: false

  alias Materia.Logs.ClientLog

  alias MateriaUtils.Ecto.EctoUtil

  require Logger

  @repo Application.get_env(:materia, :repo)

  @doc """

  """
  def list_client_logs_by_params(params) do
    @repo
    |> EctoUtil.select_by_param(ClientLog, params)
  end

  @doc """
  Gets a single client_log.

  Raises `Ecto.NoResultsError` if the Client log does not exist.

  ## Examples

      iex> get_client_log!(123)
      %ClientLog{}

      iex> get_client_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_log!(id), do: @repo.get!(ClientLog, id)

  @doc """
  Creates a client_log.

  ## Examples

      iex> create_client_log(%{field: value})
      {:ok, %ClientLog{}}

      iex> create_client_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client_log(attrs \\ %{}) do
    %ClientLog{}
    |> ClientLog.changeset(attrs)
    |> @repo.insert()
  end

  alias Materia.Logs.ConnLog

  @doc """

  """
  def list_conn_logs_by_params(params) do
    @repo
    |> EctoUtil.select_by_param(ConnLog, params)
  end

  @doc """
  Gets a single conn_log.

  Raises `Ecto.NoResultsError` if the Conn log does not exist.

  ## Examples

      iex> get_conn_log!(123)
      %ConnLog{}

      iex> get_conn_log!(456)
      ** (Ecto.NoResultsError)

  """
  def get_conn_log!(id), do: @repo.get!(ConnLog, id)

  @doc """
  Creates a conn_log.

  ## Examples

      iex> create_conn_log(%{field: value})
      {:ok, %ConnLog{}}

      iex> create_conn_log(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_conn_log(attrs \\ %{}) do
    %ConnLog{}
    |> ConnLog.changeset(attrs)
    |> @repo.insert()
  end
end
