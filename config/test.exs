use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :materia, MateriaWeb.Test.Endpoint,
  http: [port: 4001],
  #server: false,
  debug_errors: true,
  code_reloader: false,
  check_origin: false,
  watchers: []

# Print only warnings and errors during test
config :logger, level: :debug

# Configure your database
config :materia, Materia.Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: "postgres",
  password: "postgres",
  database: "materia_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox

config :materia, repo: Materia.Test.Repo

# Configures GuardianDB
config :guardian, Guardian.DB,
 repo: Materia.Test.Repo,
 schema_name: "guardian_tokens", # default
#token_types: ["refresh_token"], # store all token types if not set
 sweep_interval: 60 # default: 60 minutes


# Configure materia mail
config :materia, Materia.Mails.MailClient,
# use AmazonSES settings
#  client_module: Materia.Mails.MailClientAwsSes,
#  mail_ses_region: "us-west-2"

# use SendGrid settings
# client_module: Materia.Mails.MailClientSendGrid
#
#config :sendgrid,
# api_key: "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"

# use StubMailClient settings
 client_module: Materia.Mail.MailClientStub

# Configure materia user registration flow mails
config :materia, Materia.Accounts,
  system_from_email: "team_bi@karabiner.tech",
  system_from_name: "カラビナテクノロジーテスト事務局", # not effect when use Materia.Mails.MailClientAwsSes
  user_registration_request_mail_template_type: "user_registration_request",
  user_registration_url: "hogehoge.example.com/user-registration",
  user_registration_completed_mail_template_type: "user_registration_completed",
  sign_in_url: "hogehoge.example.com/sign-in",
  password_reset_request_mail_template_type: "password_reset_request",
  password_reset_url: "hogehoge.example.com/pw-reset",
  password_reset_completed_mail_template_type: "password_reset_completed"


