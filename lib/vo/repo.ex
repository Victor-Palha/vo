defmodule Vo.Repo do
  use Ecto.Repo,
    otp_app: :vo,
    adapter: Ecto.Adapters.Postgres
end
