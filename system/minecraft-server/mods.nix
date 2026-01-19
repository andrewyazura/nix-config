{ pkgs }:
with pkgs;
{
  "fabric-api" = fetchurl {
    url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/DdVHbeR1/fabric-api-0.141.1+1.21.11.jar";
    sha512 = "0pk785blm80s8549g0v3ha2j65vpz3q8fy0gfkblvxj844kpxkh78mq2rhy4zmw7yx89hj2yh6635kidh6wk669vwwk14i2pvf4anqq";
  };
  "skin-restorer" = fetchurl {
    url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/8K5Fuf9S/skinrestorer-2.4.3+1.21.11-fabric.jar";
    sha512 = "1wv85zxwbm61xmimjf1zxh25cldqir3ghyd08376mq144lvyix4z92wgb730m4nhliizhazxqkz0mrc316gbkcpj1lz2yz038y0868s";
  };
  "lithium" = fetchurl {
    url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/gl30uZvp/lithium-fabric-0.21.2+mc1.21.11.jar";
    sha512 = "2v3nv6wl4jmnjw924zk1jf1ppgq78asgb14sv2p1xk6ad3vs2a6s12z45c8d1jzrnqaa6zr41igycn9cfjdidp2qbqsl39y0485aqll";
  };
  "vanish" = fetchurl {
    url = "https://cdn.modrinth.com/data/UL4bJFDY/versions/NpTm6CT2/vanish-1.6.6+1.21.11.jar";
    sha512 = "29369705ldwn50j3wh763v00grxsaafk2gnxxrsxr2l6xmh12vnwnn7ln7qcc8z71bf7z6c79g7ikq0851r378bp7c99xlmyiwxfjs1";
  };
  "proxy-protocol-support" = fetchurl {
    url = "https://cdn.modrinth.com/data/mfONdVnp/versions/pvePrqOz/proxy-protocol-support-1.1.0-fabric.jar";
    sha512 = "343lzllrcqa2d7nz4y1jdzbh2jm3x9jrfmkmm4aiacmb6rwbab1awlw5jzlx4gq1qxz1fjmr5vkfwdp58rfv76r1iplx4jrvksngl37";
  };
  "easy-auth" = fetchurl {
    url = "https://cdn.modrinth.com/data/aZj58GfX/versions/LPQE6Dfu/easyauth-mc1.21.11-3.4.1.jar";
    sha512 = "3n1wngbrvlg1k9wlvwp7ca226080cj9n57d15a0cj2iizahzfvc6wpnjgyh9kcf78s8c7f5qczlhps785zc4vrx1px6ql90l8br89x8";
  };
}
