[INDEX](../)

---

# K3OS

## Set password

```bash
sudo passwd rancher
```

## SSH Access

- Path: `/var/lib/rancher/k3os/config.yaml`

```yaml
ssh_authorized_keys:
- "ssh-rsa AAAA..."
- "github:KEINOS"
```

- Ref:
  - https://github.com/rancher/k3os#configuration-reference

## Login via SSH with GitHub account

```bash
ssh -i ~/.ssh/id_rsa rancher@192.168.10.123
```

- `~/.ssh/id_rsa`
  - The secret key of GitHub account or the one set in `config.yaml`.
- `rancher`
  - Login user
- `192.168.10.123`
  - IP address of the K3OS server
- If `Permission denied (publickey,keyboard-interactive).` appears during login then the publickey of GitHub account is not added to the below path:
  - `/var/lib/rancher/etc/config.yaml`

## Shutdown

```bash
# K3OS is based on Alpine linux so it does not have a shutdown command.
sudo poweroff
```

## View nodes

```bash
kubectl get nodes
```

## Path of the key (Node Token) to share with other nodes

The token of the server node, used as the value of "K3S_TOKEN" when configuring the worker node. You need to have `root` privileges to read this file.

```bash
/var/lib/rancher/k3s/server/node-token
```

## Set up worker node

- Ref:
  - https://rancher.com/docs/k3s/latest/en/quick-start/#install-script

- Install `k3s` with worker node configuration

    ```bash
    sudo su -
    curl -sfL https://get.k3s.io | K3S_URL=https://<myserver>:6443 K3S_TOKEN=<myservernodetoken> INSTALL_K3S_VERSION=v<X.Y.Z> K3S_NODE_NAME=<this_node_name> sh -
    ```

## Install Rancher on VM

- Preparation

```bash
sudo su -
mkdir -p /etc/rancher/rke2
vi /etc/rancher/rke2/config.yaml
```

```yaml
token: <mysecretkey>
tls-san:
  - <ip_address_of_the_server>
```

- Install Rancherd

```bash
curl -sfL https://get.rancher.io | sh -
rancherd --help
```

- Set and start service

```bash
systemctl enable rancherd-server.service
systemctl start rancherd-server.service
```

- Check service

```bash
journalctl -eu rancherd-server -f

## K3S on RaspberryPi3

### Before K3S installation

- Use 64bit RaspberryPi OS Lite.
- On RaspberryPi you need to add the below to the `/boot/cmdline.txt` file:
  - `cgroup_memory=1 cgroup_enable=memory`
- Make sure the the below configuration is added to the `/boot/config.txt` file:
  - `arm_64bit=1`
  - `gpu_mem=16`

## Japanese Manual of K3S

- [https://rancher.co.jp/pdfs/K3s-eBook4Styles0507.pdf](https://rancher.co.jp/pdfs/K3s-eBook4Styles0507.pdf)

## Difference between "agent" and "worker" node

## Difference between "cluster" and "server" node