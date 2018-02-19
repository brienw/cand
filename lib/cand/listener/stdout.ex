defmodule Cand.Listener.Stdout do
  @behaviour Cand.Listener

  def listen(:ok) do
    IO.puts "OK"
  end

  def listen({:error, msg}) do
    IO.puts "ERROR: #{msg}"
  end

  def listen({:socket_closed, port}) do
    IO.puts "Socket Closed: #{port}"
  end

  def listen(msg) do
    IO.puts msg
  end
end
