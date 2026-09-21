defmodule Vo.Contexts.CompanhiasTest do
  use Vo.DataCase, async: true

  alias Vo.Contexts.Companhias
  alias Vo.Schemas.Companhia

  @valid_cnpj "12.345.678/0001-99"
  @valid_cpf "111.444.777-35"

  describe "create_companhia/1" do
    test "creates a companhia from cnpj and cpf alone, fetching the rest" do
      assert {:ok, %Companhia{} = companhia} =
               Companhias.create_companhia(%{"cnpj" => @valid_cnpj, "cpf" => @valid_cpf})

      assert companhia.cnpj == "12345678000199"
      assert companhia.cpf_responsavel == "11144477735"
      assert companhia.nome == "Teste Corp"
      assert companhia.nome_comercial == "EMPRESA TESTE LTDA"
      assert companhia.nome_responsavel == "Fulano de Tal"
      assert companhia.ativo == true
    end

    test "returns an error when the cnpj is invalid" do
      assert {:error, "CNPJ inválido"} =
               Companhias.create_companhia(%{"cnpj" => "00000000000000", "cpf" => @valid_cpf})
    end

    test "returns an error when the cpf is invalid" do
      assert {:error, "CPF inválido"} =
               Companhias.create_companhia(%{"cnpj" => @valid_cnpj, "cpf" => "00000000000"})
    end

    test "enforces cnpj uniqueness" do
      assert {:ok, %Companhia{}} =
               Companhias.create_companhia(%{"cnpj" => @valid_cnpj, "cpf" => @valid_cpf})

      assert {:error, changeset} =
               Companhias.create_companhia(%{"cnpj" => @valid_cnpj, "cpf" => @valid_cpf})

      assert %{cnpj: ["has already been taken"]} = errors_on(changeset)
    end
  end

  describe "list_companhias/0 and get_companhia!/1" do
    test "lists and fetches persisted companhias" do
      {:ok, companhia} =
        Companhias.create_companhia(%{"cnpj" => @valid_cnpj, "cpf" => @valid_cpf})

      assert Companhias.list_companhias() == [companhia]
      assert Companhias.get_companhia!(companhia.id) == companhia
    end
  end

  describe "update_companhia/2" do
    test "updates editable fields" do
      {:ok, companhia} =
        Companhias.create_companhia(%{"cnpj" => @valid_cnpj, "cpf" => @valid_cpf})

      assert {:ok, updated} =
               Companhias.update_companhia(companhia, %{
                 "contato_responsavel" => "fulano@teste.com",
                 "ativo" => false
               })

      assert updated.contato_responsavel == "fulano@teste.com"
      assert updated.ativo == false
    end
  end

  describe "delete_companhia/1" do
    test "removes the companhia" do
      {:ok, companhia} =
        Companhias.create_companhia(%{"cnpj" => @valid_cnpj, "cpf" => @valid_cpf})

      assert {:ok, %Companhia{}} = Companhias.delete_companhia(companhia)
      assert_raise Ecto.NoResultsError, fn -> Companhias.get_companhia!(companhia.id) end
    end
  end
end
