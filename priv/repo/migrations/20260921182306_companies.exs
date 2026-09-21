defmodule Vo.Repo.Migrations.Companies do
  use Ecto.Migration

  def change do
    create table(:companhias) do
      add :nome, :string, null: false
      add :nome_comercial, :string, null: false
      add :cnpj, :string, null: false
      add :nome_responsavel, :string, null: false
      add :cpf_responsavel, :string, null: false
      add :contato_responsavel, :string
      add :ativo, :boolean, null: false, default: true
      add :numero_usuarios, :integer, null: false, default: 5
      add :numero_projetos, :integer, null: false, default: 5

      timestamps()
    end

    create unique_index(:companhias, [:cnpj])
  end
end
