[INDEX](../)

---

# IPFS

## List peer nodes (Observe peers)

```bash
ipfs swarm peers
```

## Wrap files with a directory object when adding to IPFS

```bash
ipfs add -w <file>
```

## View all pinned files

```bash
ipfs pin ls
```

## How to generate swarm-key for private IPFS network

- https://zenn.dev/shmn7iii/articles/516131d9563396 （日本語）
- https://github.com/ipfs/go-ipfs/blob/release-v0.9.0/docs/experimental-features.md#private-networks
- https://github.com/ahester57/ipfs-private-swarm#2-generate-swarmkey
- Article of Pintia about private nodes
  - https://medium.com/pinata/dedicated-ipfs-networks-c692d53f938d

## How to set swarm-key for JS-IPFS

- https://discuss.ipfs.io/t/js-ipfs-swarm-key-for-private-network/3849/11
