# embassyOS Debian Package Builder

## Building

- current latest

```
make clean
make
```

- a specific version

```
make clean
make VERSION=0.3.2
```

- a specific branch (i.e. next)

```
make clean
make TAG=next
```

## Installing (ideally on a bare debian VM)

Replace `0.3.2` with whatever version you built

```
sudo dpkg -i embassyos-0.3.2-1_amd64.deb
sudo apt install -yf
```
