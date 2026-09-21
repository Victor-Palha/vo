defmodule Vo.Utils.Cpf.CpfMockValidatorTest do
  use ExUnit.Case, async: true

  alias Vo.Utils.Cpf.CpfMockValidator

  describe "validate/1" do
    test "returns ok with a canned name for any well-formed cpf" do
      assert {:ok, %{cpf: "11144477735", name: "Fulano de Tal"}} =
               CpfMockValidator.validate("111.444.777-35")
    end

    test "returns error for known invalid mock cpfs" do
      assert {:error, "CPF inválido"} = CpfMockValidator.validate("00000000000")
      assert {:error, "CPF inválido"} = CpfMockValidator.validate("11111111111")
    end
  end
end
