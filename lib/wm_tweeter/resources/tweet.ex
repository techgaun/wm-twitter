defmodule WmTweeter.Resources.Tweet do
  def init(_), do: {:ok, {nil, []}}
  def ping(req_data, state), do: {:pong, req_data, state}

  def allowed_methods(req_data, state) do
    {[:POST], req_data, state}
  end

  def resource_exists(req_data, state) do
    {false, req_data, state}
  end

  def post_is_create(req_data, state) do
    {true, req_data, state}
  end

  def allow_missing_post(req_data, state) do
    {true, req_data, state}
  end

  def create_path(req_data, {_id, attrs}) do
    new_id = System.monotonic_time
    {'/tweets/#{new_id}', req_data, {new_id, attrs}}
  end

  def content_types_accepted(req_data, state) do
    {[{'application/json', :from_json}], req_data, state}
  end

  def from_json(req_data, {id, attrs}) do
    try do
      req_body = :wrq.req_body(req_data)
      {:struct, [{"tweet", {:struct, attrs}}]} = :mochijson2.decode(req_body) |> IO.inspect
      {"message", msg} = List.keyfind(attrs, "message", 0)
      {"avatar", avatar} = List.keyfind(attrs, "avatar", 0)
      new_attrs = [avatar: avatar, message: msg, time: :erlang.timestamp]
      :ets.insert(:tweets, [{id, new_attrs}])
      {true, req_data, {id, new_attrs}}
    rescue _err in [MatchError, CaseClauseError] ->
      {false, req_data, {id, attrs}}
    end
  end
end
