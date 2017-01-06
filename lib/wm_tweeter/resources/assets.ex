defmodule WmTweeter.Resources.Assets do
  def init(_), do: {:ok, %{}}

  def ping(req_data, state), do: {:pong, req_data, state}

  def produce_resource(req_data, %{filename: f} = state) do
    {File.read!(f), req_data, state}
  end

  def resource_exists(req_data, state) do
    priv_dir = Path.join(:code.priv_dir(:wm_tweeter), "www")
    abs_path = Path.join(priv_dir, identify_file(req_data)) |> Path.expand
    state = Map.put(state, :filename, abs_path)

    if File.regular?(abs_path) do
      state = Map.put(state, :fileinfo, File.stat!(abs_path))
      {true, req_data, state}
    else
      {false, req_data, state}
    end
  end

  def content_types_provided(req_data, state) do
    mtype = req_data
            |> identify_file
            |> String.to_charlist
            |> :webmachine_util.guess_mime()
    {[{mtype, :produce_resource}], req_data ,state}
  end

  def encodings_provided(req_data, state) do
    {
      [
        {'identity', &(&1)},
        {'gzip', &:zlib.gzip/1},
        {'deflate', &:zlib.zip/1}
      ],
      req_data, state
    }
  end

  def last_modified(req_data, %{fileinfo: finfo} = state) do
    {finfo.mtime, req_data, state}
  end

  def generate_etag(req_data, %{fileinfo: finfo} = state) do
    hash = {finfo.inode, finfo.mtime}
      |> :erlang.phash2
      |> :mochihex.to_hex
    {hash, req_data, state}
  end

  defp identify_file(req_data) do
    case :wrq.path_tokens(req_data) do
      [] -> ["index.html"]
      toks -> toks
    end
    |> Path.join
  end
end
