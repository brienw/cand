# Cand

**TODO: Add description**

```
{:ok, pid} = Cand.Socket.start_link
Cand.Protocol.connect(pid, {192,168,0,12}, 28600)
Cand.Protocol.open(pid, 'can0')
Cand.Protocol.rawmode(pid)
```

```
Cand.Protocol.send(pid, "295", 8, "64 6E 74 70 61 6E 69 63")
```

## Socket

connect(Socket, host, port)

connect(host, port)

{:ok, Socket} = Socket.connect(Socket, host, port)

{:ok, Socket} = Socket.connect(host, port)

## Protocol

connect(host, port)

open(pid, canbus)

send(pid, can_id, ...)

echo(pid)

rawmode(pid)

bcmmode(pid)