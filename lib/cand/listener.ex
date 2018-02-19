defmodule Cand.Listener do
  @moduledoc """
    Message handler for TCP socket messages.
  """
  @callback listen(arg ::any ) :: nil

  # listen(:ok)
  # listen({:error, message :: String.t})
  # listen({:socket_closed, port :: port})
end
