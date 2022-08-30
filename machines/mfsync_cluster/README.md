# deployment
```
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/mfsync_cluster_key
```

```
nix develop
nixops deploy -d mfsync_cluster --force-reboot
```
