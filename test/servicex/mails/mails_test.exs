defmodule Servicex.MailsTest do
  use Servicex.DataCase

  alias Servicex.Mails

  describe "templates" do
    alias Servicex.Mails.Template

    @valid_attrs %{body: "some body", lock_version: 42, status: 42, string: "some string", subject: "some subject"}
    @update_attrs %{body: "some updated body", lock_version: 43, status: 43, string: "some updated string", subject: "some updated subject"}
    @invalid_attrs %{body: nil, lock_version: nil, status: nil, string: nil, subject: nil}

    def template_fixture(attrs \\ %{}) do
      {:ok, template} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Mails.create_template()

      template
    end

    test "list_templates/0 returns all templates" do
      template = template_fixture()
      assert Mails.list_templates() == [template]
    end

    test "get_template!/1 returns the template with given id" do
      template = template_fixture()
      assert Mails.get_template!(template.id) == template
    end

    test "create_template/1 with valid data creates a template" do
      assert {:ok, %Template{} = template} = Mails.create_template(@valid_attrs)
      assert template.body == "some body"
      assert template.lock_version == 42
      assert template.status == 42
      assert template.string == "some string"
      assert template.subject == "some subject"
    end

    test "create_template/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Mails.create_template(@invalid_attrs)
    end

    test "update_template/2 with valid data updates the template" do
      template = template_fixture()
      assert {:ok, template} = Mails.update_template(template, @update_attrs)
      assert %Template{} = template
      assert template.body == "some updated body"
      assert template.lock_version == 43
      assert template.status == 43
      assert template.string == "some updated string"
      assert template.subject == "some updated subject"
    end

    test "update_template/2 with invalid data returns error changeset" do
      template = template_fixture()
      assert {:error, %Ecto.Changeset{}} = Mails.update_template(template, @invalid_attrs)
      assert template == Mails.get_template!(template.id)
    end

    test "delete_template/1 deletes the template" do
      template = template_fixture()
      assert {:ok, %Template{}} = Mails.delete_template(template)
      assert_raise Ecto.NoResultsError, fn -> Mails.get_template!(template.id) end
    end

    test "change_template/1 returns a template changeset" do
      template = template_fixture()
      assert %Ecto.Changeset{} = Mails.change_template(template)
    end
  end
end
