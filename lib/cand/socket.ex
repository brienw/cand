defmodule Cand.Socket do
  alias Cand.Listener
  @moduledoc """
    TCP socket handler for socketcand endpoint.
  """
  use GenServer

  @initial_state %{socket: nil, listener: nil}

  def init(state), do: {:ok, state}

  def start_link do
    GenServer.start_link(__MODULE__, @initial_state)
  end

  def connect(pid, host, port, opts \\ []) do
    GenServer.call(pid, {:connect, host, port, opts})
  end

  def listen(pid, listener) do
    GenServer.call(pid, {:listen, listener})
  end

  def receive(pid) do
    GenServer.call(pid, {:recv})
  end

  def send(pid, msg) do
    GenServer.call(pid, {:send, msg})
  end

  def send_receive(pid, msg) do
    GenServer.call(pid, {:send_receive, msg})
  end

  def handle_call({:connect, host, port, opts}, _from_, state) do
    listener = Keyword.get(opts, :listener, Listener.Stdout)
    {:ok, socket} = :gen_tcp.connect(host, port, opts)
    {:reply, {:ok, host: host, port: port, opts: opts}, %{state | socket: socket, listener: listener}}
  end

  def handle_call({:listen, listener}, _from_, state) do
    {:reply, :ok, %{state | listener: listener}}
  end

  def handle_call({:recv}, _from_, %{socket: socket} = state) do
    {:ok, msg} = :gen_tcp.recv(socket, 0)
    {:reply, msg, state}
  end

  def handle_call({:send, msg}, _from_, %{socket: socket} = state) do
    :ok = :gen_tcp.send(socket, msg)
    {:reply, msg, state}
  end

  def handle_call({:send_receive, msg}, _from_, %{socket: socket} = state) do
    :ok = :gen_tcp.send(socket, msg)
    {:ok, response} = :gen_tcp.recv(socket, 0)
    {:reply, response, state}
  end

  def handle_info({:tcp, _, message}, %{listener: listener} = state) do
    message
    |> List.to_string
    |> parse_messages
    |> Enum.map(fn(message) ->
      listener.listen message
    end)
    {:noreply, state}
  end

  def handle_info({:tcp_closed, port}, %{listener: listener} = state) do
    listener.listen {:socket_closed, port}
    {:noreply, state}
  end

  defp parse_messages(messages) do
    messages
    |> String.split("><")
    |> Enum.map(fn(frame) ->
      frame
      |> String.trim("<")
      |> String.trim(">")
      |> String.trim
      |> parse_message
    end)
  end

  defp parse_message("ok"), do: :ok
  defp parse_message("hi"), do: :ok
  defp parse_message("frame " <> frame), do: frame
  defp parse_message("error " <> message), do: {:error, message}
  defp parse_message(message), do: {:error, message}

end
