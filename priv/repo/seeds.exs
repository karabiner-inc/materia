# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Servicex.Repo.insert!(%Servicex.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Servicex.Accounts.Grant

Servicex.Repo.insert!(%Grant{ role: "anybody", method: "ANY", request_path: "/api/ops/users" })
Servicex.Repo.insert!(%Grant{ role: "admin", method: "GET", request_path: "/api/ops/grants" })
