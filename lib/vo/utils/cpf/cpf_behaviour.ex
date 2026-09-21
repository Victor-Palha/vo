defmodule Vo.Utils.Cpf.CpfBehaviour do
  @moduledoc """
  Behaviour module defining the contract for CPF validation. This allows for different implementations (e.g., real check-digit validation, mocks) to be used interchangeably in the application.
  """
  @type cpf_response :: %{
          cpf: String.t(),
          name: String.t() | nil
        }
  @callback validate(cpf :: String.t()) :: {:ok, cpf_response()} | {:error, String.t()}
end
