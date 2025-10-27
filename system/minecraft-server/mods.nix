{ pkgs }:
with pkgs; {
  "fabric-api" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/P7dR8mSH/versions/lxeiLRwe/fabric-api-0.136.0%2B1.21.10.jar";
    sha512 =
      "d6ad5afeb57dc6dbe17a948990fc8441fbbc13a748814a71566404d919384df8bd7abebda52a58a41eb66370a86b8c4f910b64733b135946ecd47e53271310b5";
  };
  "distant-horizons" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/uCdwusMi/versions/9Y10ZuWP/DistantHorizons-2.3.6-b-1.21.10-fabric-neoforge.jar";
    sha512 =
      "1b1b70b7ec6290d152a5f9fa3f2e68ea7895f407c561b56e91aba3fdadef277cd259879676198d6481dcc76a226ff1aa857c01ae9c41be3e963b59546074a1fc";
  };
  "skin-restorer" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/ghrZDhGW/versions/MKWfnXfO/skinrestorer-2.4.3%2B1.21.9-fabric.jar";
    sha512 =
      "a377133467707b88834642660a3a42137acb8abfbf80dbca87508b701aa4aca3e9d1738ef3fc098627c760e6afdea32fcdf8a5835942d291ef0640f3ef3667c5";
  };
  "lithium" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/gvQqBUqZ/versions/oGKQMdyZ/lithium-fabric-0.20.0%2Bmc1.21.10.jar";
    sha512 =
      "755c0e0fc7f6f38ac4d936cc6023d1dce6ecfd8d6bdc2c544c2a3c3d6d04f0d85db53722a089fa8be72ae32fc127e87f5946793ba6e8b4f2c2962ed30d333ed2";
  };
  "very-many-players" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/wnEe9KBa/versions/ppncuwIK/vmp-fabric-mc1.21.10-0.2.0%2Bbeta.7.215-all.jar";
    sha512 =
      "4c8026c7a2ee1cfd6b4113565543f87874e5da755640123561371f7ef0bf8d86e0ea4aadd5f96ee527b3903db5b3f01c00cb8052f72e802cee2dd4f32830df59";
  };
}
