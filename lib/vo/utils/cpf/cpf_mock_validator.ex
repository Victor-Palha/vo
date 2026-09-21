defmodule Vo.Utils.Cpf.CpfMockValidator do
  @moduledoc """
  Mock implementation of the CPF validator for testing and development purposes.
  """
  @behaviour Vo.Utils.Cpf.CpfBehaviour

  @impl true
  def validate(cpf) when cpf in ["00000000000", "11111111111"] do
    {:error, "CPF inválido"}
  end

  def validate(cpf) do
    clean_cpf = String.replace(cpf, ~r/[^0-9]/, "")

    {:ok, %{cpf: clean_cpf, name: "Fulano de Tal"}}
  end
end
