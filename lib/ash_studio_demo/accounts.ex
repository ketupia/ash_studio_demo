defmodule AshStudioDemo.Accounts do
  use Ash.Domain, otp_app: :ash_studio_demo, extensions: [AshAdmin.Domain]

  admin do
    show? true
  end

  resources do
    resource AshStudioDemo.Accounts.Token
    resource AshStudioDemo.Accounts.User
  end
end
