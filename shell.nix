{ mkShell
, sops-import-keys-hook
, ssh-to-pgp
, sops-init-gpg-key
, sops
, deploy-rs
}:

mkShell {
  # imports all files ending in .asc/.gpg
  sopsPGPKeyDirs = [ 
    "./machines/secrets/keys/hosts"
    "./machines/secrets/keys/users"
  ];

  nativeBuildInputs = [
    ssh-to-pgp
    sops-import-keys-hook
    sops-init-gpg-key
    sops
    deploy-rs
  ];
}
