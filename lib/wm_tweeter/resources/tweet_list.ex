defmodule WmTweeter.Resources.TweetList do
  def init(_), do: {:ok, []}

  def ping(req_data, state), do: {:pong, req_data, state}

  def content_types_provided(req_data, state) do
    {[{'applicationi/json', :to_json}], req_data, state}
  end

  def resource_exists(req_data, _state), do: {true, req_data, :ets.tab2list(:tweets)}

  def to_json(req_data, state) do
    tweets = for {_id, attrs} <- state, do: {:struct, put_in(attrs, [:time], [convert_timestamp(attrs[:time])])}
    {:mochijson2.encode({:struct, [tweets: tweets]}), req_data, state}
  end

  defp convert_timestamp({mega, sec, micro}) do
    mega * 1000000 * 1000000 + sec * 1000000 + micro
  end
end
