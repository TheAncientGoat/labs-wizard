defmodule VltLabsWizard.Auth.GuardianSerializer do
  @behaviour Guardian.Serializer
  @moduledoc "Issues tokens"

  alias VltLabsWizard.Auth

  def for_token(user = %Auth.User{}), do: {:ok, "User:#{user.id}"}
  def for_token(_), do: {:error, "Unknown resource type"}

  def from_token("User:" <> id), do: {:ok, Auth.get_user!(id)}
  def from_token(_), do: {:error, "Unknown resource type"}
end
