defmodule AshStudioDemo.Secrets do
  use AshAuthentication.Secret

  def secret_for(
        [:authentication, :tokens, :signing_secret],
        AshStudioDemo.Accounts.User,
        _opts,
        _context
      ) do
    Application.fetch_env(:ash_studio_demo, :token_signing_secret)
  end
end
