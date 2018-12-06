defmodule Materia.Mails do
  @moduledoc """
  The Mails context.
  """

  import Ecto.Query, warn: false

  alias Materia.Mails.MailTemplate
  alias MateriaUtils.Ecto.EctoUtil

  require Logger

  @mail_client Application.get_env(:materia, Materia.Mails.MailClient)[:client_module]

  @doc """
  Returns the list of mail_templates.

  ## Examples

  ```
  iex(1)> templates = Materia.Mails.list_mail_templates()
  iex(7)> MateriaWeb.MailTemplateView.render("index.json", %{mail_templates: mail_templates})
  [
    %{
      body: "{!email}様\nこの度は当サービスへ仮登録をいただき誠にありがとうございます。\n\n本登録のご案内をいたます。\n\n下記URLのリンクをクリックし、必要情報を入力の上、30分以内に本登録操作の完了をお願いいたします。\n操作完了後\"【本登録完了しました】\"のタイトルのメールが届きましたら本登録完了となります。\n\n https://{!user_registration_url}?param=!{user_regstration_token} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------",
      id: 1,
      lock_version: 1,
      mail_template_type: "temp_registration",
      status: 1,
      subject: "【注意！登録は完了していません】本登録のご案内"
    }
  ]

  ```

  """
  def list_mail_templates do
    repo = Application.get_env(:materia, :repo)
    repo.all(MailTemplate)
  end

  @doc """

  Returns the list of mail_templates.

  ## Examples

  ```
  iex(1)> mail_templates = Materia.Mails.list_mail_templates_by_params(%{"and" => [%{"mail_template_type" => "temp_registration"}]})
  iex(2)> MateriaWeb.MailTemplateView.render("index.json", %{mail_templates: mail_templates})
  [
    %{
      body: "{!email}様\nこの度は当サービスへ仮登録をいただき誠にありがとうございます。\n\n本登録のご案内をいたます。\n\n下記URLのリンクをクリックし、必要情報を入力の上、30分以内に本登録操作の完了をお願いいたします。\n操作完了後\"【本登録完了しました】\"のタイトルのメールが届きましたら本登録完了となります。\n\n https://{!user_registration_url}?param=!{user_regstration_token} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------",
      id: 1,
      lock_version: 1,
      mail_template_type: "temp_registration",
      status: 1,
      subject: "【注意！登録は完了していません】本登録のご案内"
    }
  ]
  ```

  """
  def list_mail_templates_by_params(params) do
    repo = Application.get_env(:materia, :repo)

    repo
    |> EctoUtil.select_by_param(MailTemplate, params)
  end

  @doc """
  Gets a single mail_template.

  Raises `Ecto.NoResultsError` if the MailTemplate does not exist.

  ## Examples

  ```
  iex(1)> mail_template = Materia.Mails.get_mail_template!(1)
  iex(34)> MateriaWeb.MailTemplateView.render("show.json", %{mail_template: mail_template})
  %{
    body: "{!email}様\nこの度は当サービスへ仮登録をいただき誠にありがとうございます。\n\n本登録のご案内をいたます。\n\n下記URLのリンクをクリックし、必要情報を入力の上、30分以内に本登録操作の完了をお願いいたします。\n操作完了後\"【本登録完了しました】\"のタイトルのメールが届きましたら本登録完了となります。\n\n https://{!user_registration_url}?param=!{user_regstration_token} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------",
    id: 1,
    lock_version: 1,
    mail_template_type: "temp_registration",
    status: 1,
    subject: "【注意！登録は完了していません】本登録のご案内"
  }
  ```

  """
  def get_mail_template!(id) do
    repo = Application.get_env(:materia, :repo)
    repo.get!(MailTemplate, id)
  end

  @doc """

  ```
  iex(1)> mail_templates = Materia.Mails.list_mail_templates_by_params(%{"and" => [%{"mail_template_type" => "temp_registration"}]})
  iex(2)> MateriaWeb.MailTemplateView.render("index.json", %{mail_templates: mail_templates})
  %{
    data: [
      %{
        body: "{!email}様\nこの度は当サービスへ仮登録をいただき誠にありがとうございます。\n\n本登録のご案内をいたます。\n\n下記URLのリンクをクリックし、必要情報を入力の上、30分以内に本登録操作の完了をお願いいたします。\n操作完了後\"【本登録完了しました】\"のタイトルのメールが届きましたら本登録完了となります。\n\n https://{!user_registration_url}?param=!{user_regstration_token} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------",
        id: 1,
        lock_version: 1,
        mail_template_type: "temp_registration",
        status: 1,
        subject: "【注意！登録は完了していません】本登録のご案内"
      }
    ]
  }
  ```
  """
  def get_mail_template_by_mail_template_type(mail_template_type) do
    repo = Application.get_env(:materia, :repo)
    [mail_template] = MailTemplate
    |> where(mail_template_type: ^mail_template_type)
    |> repo.all()
    mail_template
  end

  @doc """
  Creates a mail_template.

  ## Examples

  ```
  iex(1)> {:ok, mail_template} = Materia.Mails.create_mail_template(%{mail_template_type: "test_tamplate", subject: "test_subject", body: "test body"})
  iex(2)> MateriaWeb.MailTemplateView.render("show.json", %{mail_template: mail_template}) |> Map.delete(:id)
  %{
    body: "test body",
    lock_version: 1,
    mail_template_type: "test_tamplate",
    status: 1,
    subject: "test_subject"
  }
  ```

  """
  def create_mail_template(attrs \\ %{}) do
    repo = Application.get_env(:materia, :repo)

    %MailTemplate{}
    |> MailTemplate.changeset_create(attrs)
    |> repo.insert()
  end

  @doc """
  Updates a mail_template.

  ## Examples

  ```
  iex(1)> mail_template = Materia.Mails.get_mail_template!(1)
  iex(2)> {:ok, updated_mail_template} = Materia.Mails.update_mail_template(mail_template, %{subject: "test_subject"})
  iex(3)> MateriaWeb.MailTemplateView.render("show.json", %{mail_template: updated_mail_template})
  %{
    body: "{!email}様\nこの度は当サービスへ仮登録をいただき誠にありがとうございます。\n\n本登録のご案内をいたます。\n\n下記URLのリンクをクリックし、必要情報を入力の上、30分以内に本登録操作の完了をお願いいたします。\n操作完了後\"【本登録完了しました】\"のタイトルのメールが届きましたら本登録完了となります。\n\n https://{!user_registration_url}?param=!{user_regstration_token} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------",
    id: 1,
    lock_version: 2,
    mail_template_type: "temp_registration",
    status: 1,
    subject: "test_subject"
  }
  ```

  """
  def update_mail_template(%MailTemplate{} = mail_template, attrs) do
    repo = Application.get_env(:materia, :repo)

    mail_template
    |> MailTemplate.changeset_update(attrs)
    |> repo.update()
  end

  @doc """
  Deletes a MailTemplate.

  ## Examples

  ```
  iex(1)> mail_template = Materia.Mails.get_mail_template!(1)
  iex(2)> {:ok, mail_template} = Materia.Mails.delete_mail_template(mail_template)
  iex(3)> mail_templates = Materia.Mails.list_mail_templates()
  iex(4)> MateriaWeb.MailTemplateView.render("index.json", %{mail_templates: mail_templates})
  [
    %{
      body: "{!name}様\nこの度は当サービスのご利用誠にありがとうございます。\n\n本登録が完了いたしました。\n\nIDの問い合わせ機能はない為、本メールを大切に保管してください。\n\n  ユーザーID: {!email}\n  パスワード: 登録時に入力いただいたパスワード\n 本サービスを末長くよろしくお願いいたします。\n\n https://{!sign_in_url} \n\n------------------------------\nカラビナテクノロジー株式会社\n〒810-0001 \n福岡市中央区天神1-2-4 農業共済ビル2F\n------------------------------",
      id: 2,
      lock_version: 1,
      mail_template_type: "registerd",
      status: 1,
      subject: "【本登録完了しました{!name}様 本登録完了のご案内"
    },
  ]
  ```

  """
  def delete_mail_template(%MailTemplate{} = mail_template) do
    repo = Application.get_env(:materia, :repo)
    repo.delete(mail_template)
  end

  @doc """
 send mail action.

  ## Examples

  ```
  iex(1)> {:ok, result} = Materia.Mails.send_mail("from@example.com", "test@example.com", "test subject to {!name}", "Dier {!name} \n mail to %email%", [{"{!name}", "test user"}, {"%email%", "test@example.com"}], "test admin")
  {:ok,
  %{
    body_text: "Dier test user \n mail to test@example.com",
    from: "from@example.com",
    from_name: "test admin",
    subject: "test subject to test user",
    to: "test@example.com"
  }}
  ```
  """
  def send_mail(from_email, to_email, subject, body, replace_list, from_name \\ nil) do
    if @mail_client == nil do

      Logger.warn("mail client config not found. not send email. if you want send mail, configure like :materia, Materia.MailClient, client_module: [Mail Client Module]")

    else
      replaced_subject =
        replace_list
        |> Enum.reduce(subject, fn replace_kv, replaced_acc ->
          {place_holder, value} = replace_kv
          String.replace(replaced_acc, place_holder, value)
        end)

      replaced_body_text =
        replace_list
        |> Enum.reduce(body, fn replace_kv, replaced_acc ->
          {place_holder, value} = replace_kv
          String.replace(replaced_acc, place_holder, value)
        end)

      {:ok, result} =
        @mail_client.send_mail(from_email, to_email, replaced_subject, replaced_body_text, from_name)
    end
  end
end
