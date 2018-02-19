defmodule Cand.Protocol do
  @moduledoc """
  ...
  """
  # use GenServer
  alias Cand.Socket

  @doc """
  GenServer.init/1 callback
  """
  def init(state), do: {:ok, state}

  def connect(host, port, opts \\ [:binary, active: true]) do
    {:ok, socket} = Socket.start_link
    {:ok, _} = Socket.connect(socket, host, port, opts)
    {:ok, socket}
  end

  def set_listener(socket, listener) do
    Socket.listen(socket, listener)
  end

  def open(socket, can_device) do
    Socket.send(socket, "< open #{can_device} >")
    {:ok, can_device}
  end

  def ping(socket) do
    Socket.send(socket, '< echo >')
    {:ok, 'pong'}
  end

  def send(socket, can_id, can_dlc, data) do
    Socket.send(socket, '< send #{can_id} #{can_dlc} #{data} >')
  end

  def send_integer(socket, can_id, int) when is_integer(int) do
    enc_data = Integer.to_string(int, 16)
    can_dlc = String.length(enc_data)
    send(socket, can_id, can_dlc, enc_data)
  end

  def send_string(socket, can_id, data) do
    enc_data = Base.encode16(data)
    can_dlc = String.length(enc_data)
    send(socket, can_id, can_dlc, enc_data)
  end

  ## Mode ##

  def bcmmode(socket) do
    Socket.send(socket, '< bcmmode >')
  end

  def rawmode(socket) do
    Socket.send(socket, '< rawmode >')
    {:ok}
  end

end
