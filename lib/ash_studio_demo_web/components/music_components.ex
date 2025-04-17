defmodule Tunez.MusicComponents do
  use AshStudioDemoWeb, :html

  slot :inner_block

  def h1(assigns) do
    ~H"""
    <h1 class="text-3xl font-semibold leading-8 py-2">
      {render_slot(@inner_block)}
    </h1>
    """
  end

  slot :inner_block

  def h2(assigns) do
    ~H"""
    <h2 class="text-xl font-semibold">
      {render_slot(@inner_block)}
    </h2>
    """
  end

  attr :image, :string, default: nil

  def cover_image(assigns) do
    ~H"""
    <img :if={@image} src={@image} class="block aspect-square rounded-md w-full" />
    <div
      :if={is_nil(@image)}
      class="border border-gray-300 place-content-center grid rounded-md aspect-square"
    >
      <.icon name="hero-photo" class="bg-gray-300 w-8 h-8" />
    </div>
    """
  end

  attr :kind, :string,
    values: ~w(base primary error),
    default: "base"

  attr :inverse, :boolean, default: false
  attr :size, :string, values: ~w(sm xs md), default: "md"
  attr :class, :string, default: ""
  attr :rest, :global, include: ~w(navigate disabled patch)

  slot :inner_block

  def button_link(assigns) do
    assigns =
      assign(assigns, :theme, button_styles(assigns.kind, assigns.inverse, assigns.size))

    ~H"""
    <.link
      class={[
        @theme,
        @rest[:disabled] && "opacity-60 grayscale pointer-events-none",
        @class
      ]}
      {@rest}
    >
      {render_slot(@inner_block)}
    </.link>
    """
  end

  def button_styles(kind, inverse, size) do
    theme =
      case {kind, inverse} do
        {"base", false} ->
          "bg-gray-100"

        {"base", true} ->
          "border border-gray-500 text-gray-600"

        {"primary", false} ->
          "bg-primary-600 hover:bg-primary-700 text-white"

        {"primary", true} ->
          "border border-primary-700 text-primary-700 hover:bg-primary-50 font-semibold"

        {"error", false} ->
          "bg-error-700 hover:bg-error-800 text-white"

        {"error", true} ->
          "text-error-600 underline"

        _ ->
          ""
      end

    [
      "phx-submit-loading:opacity-75 rounded-lg font-medium leading-none inline-block",
      size == "md" && "py-3 px-5 text-sm",
      size == "sm" && "py-2 px-3 text-sm",
      size == "xs" && "py-2 px-2 text-xs",
      theme
    ]
  end

  attr :user, :any
  attr :class, :string, default: ""

  def avatar(assigns) do
    assigns = assign(assigns, :seed, avatar_seed(assigns.user))

    ~H"""
    <img
      class={["rounded-full size-8", @class]}
      src={"https://api.dicebear.com/9.x/shapes/svg?seed=#{@seed}"}
    />
    """
  end

  def avatar_seed(user) do
    email =
      to_string(user.email)
      |> String.trim()
      |> String.downcase()

    :crypto.hash(:sha256, email)
    |> Base.encode16(case: :lower)
  end

  def time_ago_in_words(datetime) do
    diff = DateTime.diff(DateTime.utc_now(), datetime)

    cond do
      diff <= 5 ->
        "now"

      diff <= 60 ->
        ngettext("%{num} second ago", "%{num} seconds ago", diff, num: diff)

      diff <= 3600 ->
        num = div(diff, 60)
        ngettext("%{num} minute ago", "%{num} minutes ago", num, num: num)

      diff <= 24 * 3600 ->
        num = div(diff, 3600)
        ngettext("%{num} hour ago", "%{num} hours ago", num, num: num)

      diff <= 7 * 24 * 3600 ->
        num = div(diff, 24 * 3600)
        ngettext("%{num} day ago", "%{num} days ago", num, num: num)

      diff <= 30 * 24 * 3600 ->
        num = div(diff, 7 * 24 * 3600)
        ngettext("%{num} week ago", "%{num} weeks ago", num, num: num)

      diff <= 365 * 24 * 3600 ->
        num = div(diff, 30 * 24 * 3600)
        ngettext("%{num} month ago", "%{num} months ago", num, num: num)

      true ->
        "over a year ago"
    end
  end
end
