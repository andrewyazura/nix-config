{ username, ... }: {
  users.users.${username} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICdMxw11eBmyXj7s+oFYx9Jpg7dTaDy0qb4STBXoeAH/ andrew@yorha2b"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdUlLMeczNPLgGu/4js6yGMdW1JCr2yUXKUGQUSKxNH andrew@yorha9s"
    ];
  };
}
