{ username, ... }: {
  users.users.${username} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAdUlLMeczNPLgGu/4js6yGMdW1JCr2yUXKUGQUSKxNH andrew@yorha9s"
    ];
  };
}
