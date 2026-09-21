defmodule Vo.Utils.Cpf.CpfValidatorTest do
  use ExUnit.Case, async: true

  alias Vo.Utils.Cpf.CpfValidator

  describe "validate/1" do
    test "returns ok for a valid cpf, ignoring formatting" do
      assert {:ok, %{cpf: "11144477735", name: nil}} = CpfValidator.validate("111.444.777-35")
      assert {:ok, %{cpf: "11144477735", name: nil}} = CpfValidator.validate("11144477735")
    end

    test "returns error when the check digits are wrong" do
      assert {:error, "CPF inválido"} = CpfValidator.validate("123.456.789-00")
    end

    test "returns error when all digits are the same" do
      assert {:error, "CPF inválido"} = CpfValidator.validate("111.111.111-11")
    end

    test "returns error when the cpf does not have 11 digits" do
      assert {:error, "CPF inválido"} = CpfValidator.validate("123")
    end
  end
end
