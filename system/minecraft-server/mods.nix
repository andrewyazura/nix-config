{ pkgs }:
with pkgs; {
  "fabric-api" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/P7dR8mSH/versions/DdVHbeR1/fabric-api-0.141.1+1.21.11.jar";
    sha512 = "0pk785blm80s8549g0v3ha2j65vpz3q8fy0gfkblvxj844kpxkh78mq2rhy4zmw7yx89hj2yh6635kidh6wk669vwwk14i2pvf4anqq";
  };
  "distant-horizons" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/uCdwusMi/versions/GT3Bm3GN/DistantHorizons-2.4.5-b-1.21.11-fabric-neoforge.jar";
    sha512 = "3hnbwfpqawp6z5brlwxvwfv3iinrs0rsmqs0mdr63ffp23w8lxg22z7inpm764pr6rna6zgpfr5x8gi4vkwns2176vm9xgnq7x77xm9";
  };
  "skin-restorer" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/ghrZDhGW/versions/8K5Fuf9S/skinrestorer-2.4.3+1.21.11-fabric.jar";
    sha512 = "1wv85zxwbm61xmimjf1zxh25cldqir3ghyd08376mq144lvyix4z92wgb730m4nhliizhazxqkz0mrc316gbkcpj1lz2yz038y0868s";
  };
  "lithium" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/gvQqBUqZ/versions/gl30uZvp/lithium-fabric-0.21.2+mc1.21.11.jar";
    sha512 = "2v3nv6wl4jmnjw924zk1jf1ppgq78asgb14sv2p1xk6ad3vs2a6s12z45c8d1jzrnqaa6zr41igycn9cfjdidp2qbqsl39y0485aqll";
  };
}
