defmodule Issues.GithubIssues do
  @user_agent [{"User-agent", "Elixir lisandromartinez@gmail.com"}]
  @github_url Application.get_env(:issues, :github_url)

  @spec fetch(any, any) :: {:error, any} | {:ok, any}
  def fetch(user, project) do
    issues_url(user, project)
    |> HTTPoison.get(@user_agent)
    |> handle_response
  end

  def issues_url(user, project) do
    "#{@github_url}/repos/#{user}/#{project}/issues"
  end

  def handle_response({:ok, %{status_code: status_code, body: body}}) do
    {
      status_code |> check_for_error(),
      body |> Jason.decode!()
      # body |> Poison.Parser.parse!()
    }
  end

  defp check_for_error(200), do: :ok
  defp check_for_error(_), do: :error
end
