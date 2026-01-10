{ pkgs }:
with pkgs; {
  "fabric-api" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/P7dR8mSH/versions/DdVHbeR1/fabric-api-0.141.1+1.21.11.jar";
    sha512 = "1ilqgffx0k4xgjara0yy8xgiki69mhqnbl97850cjcwbpn1pymva";
  };
  "distant-horizons" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/uCdwusMi/versions/GT3Bm3GN/DistantHorizons-2.4.5-b-1.21.11-fabric-neoforge.jar";
    sha512 = "0gxwhvji4k0xnzidwrvlndh81r64n6i24v253grbxxamgshwg53n";
  };
  "skin-restorer" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/ghrZDhGW/versions/8K5Fuf9S/skinrestorer-2.4.3+1.21.11-fabric.jar";
    sha512 = "1i19wbqs3shym1hdanisj59sy8zw9vlcz94iprr2vfkmcc5w1knn";
  };
  "lithium" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/gvQqBUqZ/versions/gl30uZvp/lithium-fabric-0.21.2+mc1.21.11.jar";
    sha512 = "0f87ggnrhxbnhm51wja8zp83mzjd2nlfgrg5zd5z88zffff661ii";
  };
}
