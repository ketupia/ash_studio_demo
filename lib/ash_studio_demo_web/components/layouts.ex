defmodule AshStudioDemoWeb.Layouts do
  @moduledoc """
  This module holds different layouts used by your application.

  See the `layouts` directory for all templates available.
  The "root" layout is a skeleton rendered as part of the
  application router. The "app" layout is set as the default
  layout on both `use AshStudioDemoWeb, :controller` and
  `use AshStudioDemoWeb, :live_view`.
  """
  use AshStudioDemoWeb, :html

  embed_templates "layouts/*"
end
