defmodule Vo.Schemas.Companhia do
  use Vo.Schema

  import Ecto.Changeset

  @type t :: %__MODULE__{
          id: Ecto.UUID.t() | nil,
          nome: String.t() | nil,
          nome_comercial: String.t() | nil,
          cnpj: String.t() | nil,
          nome_responsavel: String.t() | nil,
          cpf_responsavel: String.t() | nil,
          contato_responsavel: String.t() | nil,
          ativo: boolean() | nil,
          numero_usuarios: integer() | nil,
          numero_projetos: integer() | nil,
          inserted_at: NaiveDateTime.t() | nil,
          updated_at: NaiveDateTime.t() | nil
        }

  schema "companhias" do
    field :nome, :string
    field :nome_comercial, :string
    field :cnpj, :string
    field :nome_responsavel, :string
    field :cpf_responsavel, :string
    field :contato_responsavel, :string
    field :ativo, :boolean, default: true
    field :numero_usuarios, :integer, default: 5
    field :numero_projetos, :integer, default: 5
    timestamps()
  end

  def changeset(company, attrs) do
    company
    |> cast(attrs, [
      :nome,
      :nome_comercial,
      :cnpj,
      :nome_responsavel,
      :cpf_responsavel,
      :contato_responsavel,
      :ativo,
      :numero_usuarios,
      :numero_projetos
    ])
    |> validate_required([
      :nome,
      :nome_comercial,
      :cnpj,
      :nome_responsavel,
      :cpf_responsavel
    ])
    |> clean_cnpj()
    |> clean_cpf()
    |> validate_length(:cnpj, is: 14, message: "deve conter 14 dígitos")
    |> validate_length(:cpf_responsavel, is: 11, message: "deve conter 11 dígitos")
    |> unique_constraint(:cnpj)
  end

  defp clean_cnpj(changeset) do
    update_change(changeset, :cnpj, &String.replace(&1, ~r/[^0-9]/, ""))
  end

  defp clean_cpf(changeset) do
    update_change(changeset, :cpf_responsavel, &String.replace(&1, ~r/[^0-9]/, ""))
  end
end
