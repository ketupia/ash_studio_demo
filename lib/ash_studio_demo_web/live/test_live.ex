defmodule AshStudioDemoWeb.TestLive do
  use AshStudioDemoWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <h2>Domain Class Diagram</h2>
    ```mermaid {Ash.Domain.Info.Diagram.mermaid_class_diagram(Tunez.Music)} ```
    <h2>Domain Entity Relationship Diagram</h2>
    <div id="mermaid-er-container" class="shadow-lg">
      <pre class="mermaid">
        {Ash.Domain.Info.Diagram.mermaid_er_diagram(Tunez.Music)}
      </pre>
    </div>

    <h2>Artist Policy Diagram</h2>
    <pre>{Ash.Policy.Chart.Mermaid.chart(Tunez.Music.Artist)}</pre>

    <.add_mermaid />
    """
  end

  defp add_mermaid(assigns) do
    ~H"""
    <script type="module">
      import mermaid from 'https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs';
      mermaid.initialize({ startOnLoad: true });
    </script>
    """
  end
end
