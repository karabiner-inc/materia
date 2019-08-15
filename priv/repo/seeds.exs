# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Materia.Repo.insert!(%Materia.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias MateriaUtils.Test.TsvParser

alias Materia.Accounts
alias Materia.Locations

Accounts.create_grant(%{ role: "anybody", method: "ANY", request_path: "/api/ops/users" })
Accounts.create_grant(%{ role: "admin", method: "ANY", request_path: "/api/ops/grants" })
Accounts.create_grant(%{ role: "operator", method: "GET", request_path: "/api/ops/grants" })
Accounts.create_grant(%{ role: "anybody", method: "ANY", request_path: "/api/ops/organizations" })
Accounts.create_grant(%{ role: "anybody", method: "ANY", request_path: "/api/ops/mail-templates" })

{:ok, user_hogehoge} = Accounts.create_user(%{ name: "hogehoge", email: "hogehoge@example.com", password: "hogehoge", role: "admin", name_p: "name_p", fax_number: "fax_number"})
Accounts.create_user(%{ name: "fugafuga", email: "fugafuga@example.com", password: "fugafuga", role: "operator", name_p: "name_p", fax_number: "fax_number"})
Locations.create_address(%{user_id: user_hogehoge.id, subject: "living", location: "福岡県", zip_code: "810-ZZZZ", address1: "福岡市中央区", address2: "港 x-x-xx", address1_p: "address1_p", address2_p: "address2_p", address3_p: "address3_p", address3: "address3", phone_number: "phone_number", notation_org_name: "notation_org_name", notation_org_name_p: "notation_org_name_p", notation_name: "notation_name", notation_name_p: "notation_name_p", fax_number: "fax_number"})
Locations.create_address(%{user_id: user_hogehoge.id, subject: "billing", location: "福岡県", zip_code: "810-ZZZZ", address1: "福岡市中央区", address2: "大名 x-x-xx", address1_p: "address1_p", address2_p: "address2_p", address3_p: "address3_p", address3: "address3", phone_number: "phone_number", notation_org_name: "notation_org_name", notation_org_name_p: "notation_org_name_p", notation_name: "notation_name", notation_name_p: "notation_name_p", fax_number: "fax_number"})

alias Materia.Organizations

{:ok, organization_hogehoge} = Organizations.create_organization( %{name: "hogehoge.inc", one_line_message: "let's do this.", back_ground_img_url: "https://hogehoge.com/ib_img.jpg", profile_img_url: "https://hogehoge.com/prof_img.jpg", hp_url: "https://hogehoge.inc", ext_organization_id: "ext_organization_id", ext_organization_branch_id: "ext_organization_branch_id", name_p: "name_p", fax_number: "fax_number"})
Accounts.update_user(user_hogehoge, %{organization_id: organization_hogehoge.id})
Locations.create_address(%{organization_id: organization_hogehoge.id, subject: "registry", location: "福岡県", zip_code: "810-ZZZZ", address1: "福岡市中央区", address2: "天神 x-x-xx", address1_p: "address1_p", address2_p: "address2_p", address3_p: "address3_p", address3: "address3", phone_number: "phone_number", notation_org_name: "notation_org_name", notation_org_name_p: "notation_org_name_p", notation_name: "notation_name", notation_name_p: "notation_name_p", fax_number: "fax_number"})
Locations.create_address(%{organization_id: organization_hogehoge.id, subject: "branch", location: "福岡県", zip_code: "812-ZZZZ", address1: "北九州市小倉北区", address2: "浅野 x-x-xx", address1_p: "address1_p", address2_p: "address2_p", address3_p: "address3_p", address3: "address3", phone_number: "phone_number", notation_org_name: "notation_org_name", notation_org_name_p: "notation_org_name_p", notation_name: "notation_name", notation_name_p: "notation_name_p", fax_number: "fax_number"})

{:ok, account} = Accounts.create_account(%{"external_code" => "hogehoge_code", "name" => "hogehoge account", "start_datetime" => "2019-01-10T10:03:50.293740Z", "main_user_id" => user_hogehoge.id, "organization_id" => organization_hogehoge.id})

alias Materia.Mails

Mails.create_mail_template(%{ mail_template_type: "user_registration_request", subject: "【注意！登録は完了していません】{!email}様 本登録のご案内", body: "{!email}様\nこの度は当サービスへ仮登録をいただき誠にありがとうございます。\n\n本登録のご案内をいたます。\n\n下記URLのリンクをクリックし、必要情報を入力の上、30分以内に本登録操作の完了をお願いいたします。\n操作完了後\"【本登録完了しました】\"のタイトルのメールが届きましたら本登録完了となります。\n\n https://{!user_registration_url}?param=!{user_regstration_token} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------" })
Mails.create_mail_template(%{ mail_template_type: "user_registration_completed", subject: "【本登録完了しました】{!name}様 本登録完了のご案内", body: "{!name}様\nこの度は当サービスのご利用誠にありがとうございます。\n\n本登録が完了いたしました。\n\nIDの問い合わせ機能はない為、本メールを大切に保管してください。\n\n  ユーザーID: {!email}\n  パスワード: 登録時に入力いただいたパスワード\n 本サービスを末長くよろしくお願いいたします。\n\n サインイン: https://{!sign_in_url} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------" })
Mails.create_mail_template(%{ mail_template_type: "password_reset_request", subject: "【パスワード再登録申請】{!email}様 パスワード再登録のご案内", body: "{!email}様\n当サービスよりパスワード再登録の申請を受け付けました。\n\n下記URLのリンクをクリックし、30分以内にパスワード再登録をお願いいたします。\n\n 本サービスを末長くよろしくお願いいたします。\n\n https://{!password_reset_url}?param=!{password_reset_token} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------" })
Mails.create_mail_template(%{ mail_template_type: "password_reset_completed", subject: "【パスワード再登録完了】{!name}様 パスワード再登録完了のご案内", body: "{!name}様\n当サービスよりパスワードが再登録されました。\n\nユーザーID: {!email}\n  パスワード: 再登録時に入力いただいたパスワード\n\n 本サービスを末長くよろしくお願いいたします。\n\n サインイン: https://{!sign_in_url} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------" })

Materia.Definitions.create_value_definition(%{definition_category: "Test1", definition_name: "定義1", definition_code: "Test_1_01", definition_value: "定義値1_1", definition_abbreviated: "1_1", display_sort_no: "1", language_code: "JP"})
Materia.Definitions.create_value_definition(%{definition_category: "Test1", definition_name: "定義1", definition_code: "Test_1_02", definition_value: "定義値1_2", definition_abbreviated: "1_2", display_sort_no: "2", language_code: "JP"})
Materia.Definitions.create_value_definition(%{definition_category: "Test1", definition_name: "定義1", definition_code: "Test_1_01", definition_value: "Definition1_1", definition_abbreviated: "1_1", display_sort_no: "1", language_code: "EN"})
Materia.Definitions.create_value_definition(%{definition_category: "Test1", definition_name: "定義1", definition_code: "Test_1_02", definition_value: "Definition1_2", definition_abbreviated: "1_2", display_sort_no: "2", language_code: "EN"})
Materia.Definitions.create_value_definition(%{definition_category: "Test2", definition_name: "定義2", definition_code: "Test_2_01", definition_value: "定義値2_1", definition_abbreviated: "2_1", display_sort_no: "1", language_code: "JP"})
Materia.Definitions.create_value_definition(%{definition_category: "Test2", definition_name: "定義2", definition_code: "Test_2_02", definition_value: "定義値2_2", definition_abbreviated: "2_2", display_sort_no: "2", language_code: "JP"})
Materia.Definitions.create_value_definition(%{definition_category: "Test2", definition_name: "定義2", definition_code: "Test_2_01", definition_value: "Definition2_1", definition_abbreviated: "2_1", display_sort_no: "1", language_code: "EN"})
Materia.Definitions.create_value_definition(%{definition_category: "Test2", definition_name: "定義2", definition_code: "Test_2_02", definition_value: "Definition2_2", definition_abbreviated: "2_2", display_sort_no: "2", language_code: "EN"})

alias Materia.Tags

tags = "
tag_category	label	normalized
hobby	car	car
hobby	cooking	cooking
hobby	elixir	elixir
skills	Elixir	elixir
skills	ELIXIR	elixir
skills	Java	 java
"

#TsvParser.parse_tsv_to_json(tags, "tag_category")
#|> Enum.map(fn j -> j |> Tags.create_tag() end)

jsons = TsvParser.parse_tsv_to_json(tags, "tag_category")

    results = jsons
    |> Enum.map(fn(json) ->
      {:ok, result} = json
      |> Tags.create_tag()
    end)
