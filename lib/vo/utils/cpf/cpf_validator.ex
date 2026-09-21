defmodule Vo.Utils.Cpf.CpfValidator do
  @moduledoc """
  Validates a CPF number using the official check-digit algorithm.

  There is no public, unauthenticated API to resolve a person's name from a
  CPF (that data is protected under Brazilian law), so this implementation
  only validates the document itself; `name` in the response is always `nil`.
  """
  @behaviour Vo.Utils.Cpf.CpfBehaviour

  @impl true
  def validate(cpf) do
    clean_cpf = String.replace(cpf, ~r/[^0-9]/, "")

    if valid_cpf?(clean_cpf) do
      {:ok, %{cpf: clean_cpf, name: nil}}
    else
      {:error, "CPF inválido"}
    end
  end

  defp valid_cpf?(cpf) when byte_size(cpf) != 11, do: false

  defp valid_cpf?(cpf) do
    digits = cpf |> String.to_charlist() |> Enum.map(&(&1 - ?0))

    if Enum.uniq(digits) |> length() == 1 do
      false
    else
      {base, [check_digit_1, check_digit_2]} = Enum.split(digits, 9)

      first_digit = checksum_digit(base)
      second_digit = checksum_digit(base ++ [first_digit])

      check_digit_1 == first_digit and check_digit_2 == second_digit
    end
  end

  defp checksum_digit(digits) do
    weight = length(digits) + 1

    sum =
      digits
      |> Enum.with_index()
      |> Enum.reduce(0, fn {digit, index}, acc -> acc + digit * (weight - index) end)

    remainder = rem(sum * 10, 11)

    if remainder >= 10, do: 0, else: remainder
  end
end
