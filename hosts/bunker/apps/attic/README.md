# Attic cache setup

This file gives the manual steps that set up the `main` cache on bunker from
scratch. It does not include deployment.

Run the `sops` commands from the repository root. `.sops.yaml` selects the
recipients, so any host can encrypt a secret for any other host. Use a Linux
host, because macOS `base64` has no `-w0` flag.

## Before the first deploy

atticd does not start without its token signing key.

- [ ] Generate the signing key and encrypt it into `secrets/attic-env`:

  ```sh
  printf 'ATTIC_SERVER_TOKEN_RS256_SECRET_BASE64="%s"\n' \
    "$(nix shell nixpkgs#openssl -c openssl genrsa -traditional 4096 | base64 -w0)" \
    | sops encrypt --filename-override secrets/attic-env > secrets/attic-env
  ```

  A new key makes all tokens invalid, including the CI token. Do all the
  steps below again after you change it.

## After the deploy

- [ ] On bunker, make a short-lived admin token:

  ```sh
  sudo atticd-atticadm make-token --sub admin --validity 1d \
    --pull main --push main --delete main \
    --create-cache main --configure-cache main \
    --configure-cache-retention main --destroy-cache main
  ```

- [ ] On your machine, log in with the admin token and create the cache:

  ```sh
  attic login bunker https://cache.andrewyazura.com <admin-token>
  attic cache create bunker:main
  ```

  The cache is private, so hosts pull with a netrc token. A push skips the
  paths that cache.nixos.org signs.

- [ ] Get the public key of the cache:

  ```sh
  attic cache info bunker:main
  ```

  Put the `Public Key` value (`main:...`) into `trusted-public-keys` in:

  - `common/binary-cache/default.nix`
  - `.github/workflows/deploy-bunker.yml`

  atticd keeps the cache key pair in its database, not in a secret. A new
  database gives the cache a new public key.

- [ ] On bunker, make one token for each host and one for CI:

  ```sh
  for sub in bunker yorha2b yorha9s yorhaA2 ci; do
    echo "$sub:"
    sudo atticd-atticadm make-token --sub "$sub" --validity 1y --pull main --push main
  done
  ```

  You cannot revoke one token. A token stops at its expiry, or when you
  change `secrets/attic-env`.

- [ ] Encrypt each host token into its netrc secret. Do this for `bunker`,
  `yorha2b`, `yorha9s` and `yorhaA2`:

  ```sh
  read -rs TOKEN
  printf 'machine cache.andrewyazura.com\npassword %s\n' "$TOKEN" \
    | sops encrypt --filename-override secrets/netrc-yorha2b > secrets/netrc-yorha2b
  ```

  A new host also needs a `secrets/netrc-<host>` rule in `.sops.yaml` and a
  `sops.secrets.netrc` entry in `hosts/<host>/default.nix`.

- [ ] Set the CI token as a GitHub secret:

  ```sh
  gh secret set ATTIC_TOKEN --repo andrewyazura/nix-config
  ```

- [ ] Commit the public key and the secrets, then deploy every host.

## Check

- [ ] On each host, make sure that the netrc token can pull:

  ```sh
  sudo curl --netrc-file /run/secrets/netrc https://cache.andrewyazura.com/main/nix-cache-info
  ```

  The output contains `StoreDir: /nix/store`.

- [ ] On each host, log in with the host token and push a test closure. This
  login replaces the admin login.

  ```sh
  attic login bunker https://cache.andrewyazura.com "$(sudo awk '{for (i = 1; i < NF; i++) if ($i == "password") print $(i + 1)}' /run/secrets/netrc)"
  attic push bunker:main /run/current-system
  ```
