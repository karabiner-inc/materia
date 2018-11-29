defmodule Materia.MailsTest do
  use Materia.DataCase

  alias Materia.Mails

  describe "mail_templates" do
    alias Materia.Mails.MailTemplate

    @valid_attrs %{body: "some body", lock_version: 42, status: 42, string: "some string", subject: "some subject"}
    @update_attrs %{body: "some updated body", lock_version: 43, status: 43, string: "some updated string", subject: "some updated subject"}
    @invalid_attrs %{body: nil, lock_version: nil, status: nil, string: nil, subject: nil}

    def mail_template_fixture(attrs \\ %{}) do
      {:ok, mail_template} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Mails.create_mail_template()

      mail_template
    end

    test "list_mail_templates/0 returns all mail_templates" do
      mail_template = mail_template_fixture()
      assert Mails.list_mail_templates() == [mail_template]
    end

    test "get_mail_template!/1 returns the mail_template with given id" do
      mail_template = mail_template_fixture()
      assert Mails.get_mail_template!(mail_template.id) == mail_template
    end

    test "create_mail_template/1 with valid data creates a mail_template" do
      assert {:ok, %MailTemplate{} = mail_template} = Mails.create_mail_template(@valid_attrs)
      assert mail_template.body == "some body"
      assert mail_template.lock_version == 42
      assert mail_template.status == 42
      assert mail_template.string == "some string"
      assert mail_template.subject == "some subject"
    end

    test "create_mail_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mails.create_mail_template(@invalid_attrs)
    end

    test "update_mail_template/2 with valid data updates the mail_template" do
      mail_template = mail_template_fixture()
      assert {:ok, mail_template} = Mails.update_mail_template(mail_template, @update_attrs)
      assert %MailTemplate{} = mail_template
      assert mail_template.body == "some updated body"
      assert mail_template.lock_version == 43
      assert mail_template.status == 43
      assert mail_template.string == "some updated string"
      assert mail_template.subject == "some updated subject"
    end

    test "update_mail_template/2 with invalid data returns error changeset" do
      mail_template = mail_template_fixture()
      assert {:error, %Ecto.Changeset{}} = Mails.update_mail_template(mail_template, @invalid_attrs)
      assert mail_template == Mails.get_mail_template!(mail_template.id)
    end

    test "delete_mail_template/1 deletes the mail_template" do
      mail_template = mail_template_fixture()
      assert {:ok, %MailTemplate{}} = Mails.delete_mail_template(mail_template)
      assert_raise Ecto.NoResultsError, fn -> Mails.get_mail_template!(mail_template.id) end
    end

    test "change_mail_template/1 returns a mail_template changeset" do
      mail_template = mail_template_fixture()
      assert %Ecto.Changeset{} = Mails.change_mail_template(mail_template)
    end
  end
end
