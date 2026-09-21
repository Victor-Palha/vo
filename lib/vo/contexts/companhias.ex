defmodule Vo.Contexts.Companhias do
  @moduledoc """
  Context for CRUD operations on companhias.
  """

  alias Vo.Repo
  alias Vo.Schemas.Companhia

  @cnpj_validator Application.compile_env(:vo, :cnpj_validator, Vo.Utils.Cnpj.CnpjValidator)
  @cpf_validator Application.compile_env(:vo, :cpf_validator, Vo.Utils.Cpf.CpfValidator)

  @doc "Returns the list of companhias."
  @spec list_companhias() :: [Companhia.t()]
  def list_companhias, do: Repo.all(Companhia)

  @doc "Gets a single companhia. Raises `Ecto.NoResultsError` if not found."
  @spec get_companhia!(Ecto.UUID.t()) :: Companhia.t()
  def get_companhia!(id), do: Repo.get!(Companhia, id)

  @doc """
  Creates a companhia from a CNPJ and a CPF.

  The legal name and commercial name are fetched based on the CNPJ, and the
  responsible person's name based on the CPF; no other field is accepted.
  """
  @spec create_companhia(%{String.t() => String.t()}) ::
          {:ok, Companhia.t()} | {:error, Ecto.Changeset.t() | String.t()}
  def create_companhia(%{"cnpj" => cnpj, "cpf" => cpf}) do
    with {:ok, cnpj_data} <- @cnpj_validator.validate(cnpj),
         {:ok, cpf_data} <- @cpf_validator.validate(cpf) do
      attrs = %{
        "nome" => cnpj_data.name,
        "nome_comercial" => cnpj_data.commercial_name,
        "cnpj" => cnpj_data.cnpj,
        "nome_responsavel" => cpf_data.name,
        "cpf_responsavel" => cpf_data.cpf
      }

      %Companhia{}
      |> Companhia.changeset(attrs)
      |> Repo.insert()
    end
  end

  @doc "Updates a companhia."
  @spec update_companhia(Companhia.t(), map()) ::
          {:ok, Companhia.t()} | {:error, Ecto.Changeset.t()}
  def update_companhia(%Companhia{} = companhia, attrs) do
    companhia
    |> Companhia.changeset(attrs)
    |> Repo.update()
  end

  @doc "Deletes a companhia."
  @spec delete_companhia(Companhia.t()) :: {:ok, Companhia.t()} | {:error, Ecto.Changeset.t()}
  def delete_companhia(%Companhia{} = companhia), do: Repo.delete(companhia)
end
