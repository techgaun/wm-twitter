defmodule WmTweeter.Resources.Hello do
  def init(_), do: {:ok, nil}

  def ping(req_data, state), do: {:pong, req_data, state}

  def to_html(req_data, state) do
    {"<!DOCTYPE html><html><body>Hello, World!<br>You are not supposed to be here.</body></html>", req_data, state}
  end
end
