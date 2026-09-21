defmodule Vo.Schemas.CompanhiaTest do
  use Vo.DataCase, async: true

  alias Vo.Schemas.Companhia

  @valid_attrs %{
    "nome" => "Empresa Teste",
    "nome_comercial" => "Empresa Teste LTDA",
    "cnpj" => "12.345.678/0001-99",
    "nome_responsavel" => "Fulano de Tal",
    "cpf_responsavel" => "123.456.789-01",
    "contato_responsavel" => "fulano@teste.com"
  }

  describe "changeset/2" do
    test "is valid with valid attributes" do
      changeset = Companhia.changeset(%Companhia{}, @valid_attrs)

      assert changeset.valid?
    end

    test "requires all fields" do
      changeset = Companhia.changeset(%Companhia{}, %{})

      refute changeset.valid?

      assert %{
               nome: ["can't be blank"],
               nome_comercial: ["can't be blank"],
               cnpj: ["can't be blank"],
               nome_responsavel: ["can't be blank"],
               cpf_responsavel: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "strips non-numeric characters from cnpj" do
      changeset = Companhia.changeset(%Companhia{}, @valid_attrs)

      assert Ecto.Changeset.get_change(changeset, :cnpj) == "12345678000199"
    end

    test "strips non-numeric characters from cpf_responsavel" do
      changeset = Companhia.changeset(%Companhia{}, @valid_attrs)

      assert Ecto.Changeset.get_change(changeset, :cpf_responsavel) == "12345678901"
    end

    test "is invalid when cnpj does not have 14 digits" do
      attrs = Map.put(@valid_attrs, "cnpj", "123")
      changeset = Companhia.changeset(%Companhia{}, attrs)

      refute changeset.valid?
      assert %{cnpj: ["deve conter 14 dígitos"]} = errors_on(changeset)
    end

    test "is invalid when cpf_responsavel does not have 11 digits" do
      attrs = Map.put(@valid_attrs, "cpf_responsavel", "123")
      changeset = Companhia.changeset(%Companhia{}, attrs)

      refute changeset.valid?
      assert %{cpf_responsavel: ["deve conter 11 dígitos"]} = errors_on(changeset)
    end
  end

  describe "creation via Repo" do
    test "creates a companhia with valid attributes" do
      assert {:ok, %Companhia{} = companhia} =
               %Companhia{}
               |> Companhia.changeset(@valid_attrs)
               |> Repo.insert()

      assert companhia.cnpj == "12345678000199"
      assert companhia.cpf_responsavel == "12345678901"
      assert companhia.ativo == true
      assert companhia.numero_usuarios == 5
      assert companhia.numero_projetos == 5
    end

    test "enforces cnpj uniqueness" do
      assert {:ok, %Companhia{}} =
               %Companhia{}
               |> Companhia.changeset(@valid_attrs)
               |> Repo.insert()

      duplicate_attrs = Map.put(@valid_attrs, "nome", "Outra Empresa")

      assert {:error, changeset} =
               %Companhia{}
               |> Companhia.changeset(duplicate_attrs)
               |> Repo.insert()

      assert %{cnpj: ["has already been taken"]} = errors_on(changeset)
    end
  end
end
