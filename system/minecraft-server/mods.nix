{ pkgs }:
with pkgs;
{
  "fabric-api" = fetchurl {
    url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/bNnaTiuM/fabric-api-0.161.0%2B26.3.jar";
    sha512 = "2fi1nhjdv0rr194ln31msvdd8413a1hipwkj7xmrrvdasp17qbrkqjyrql7wpnqpza98vz44rqbd68yqlksbxbjhkg1zqgxss32aszd";
  };
  "skin-restorer" = fetchurl {
    url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/K7BFrFJD/skinrestorer-2.11.0%2B26.3-fabric.jar";
    sha512 = "0mg6dwicqn8nkv8isiz2ls2h8md8aza16b3j01w10f0ygmp6a8jwh5ayqqzbxb9x52z8qpwfshwsgwap6i5xcpbly21dyjbcnfbxyw4";
  };
  "lithium" = fetchurl {
    url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/WXHRsMRl/lithium-fabric-0.26.1%2Bmc26.3.jar";
    sha512 = "1crqr1z83p23r0a1i46di0sw1qbpg8dbf9hj53ys9vhv3rgnpn029cscccvj4lah1j7dljspd53h6b0hvcz22x20dg00gr0g81rpfxc";
  };
  "vanish" = fetchurl {
    url = "https://cdn.modrinth.com/data/UL4bJFDY/versions/1NWDWRJ6/vanish-1.6.15%2B26.3.jar";
    sha512 = "1vkjz4a04cmbs7w7zr1nz28m724l2n8947g091dsaajnmkl25jw0lipd39nrjhf72cm5zg431ffwh4q24smq6c2d4ac6g1vxxf2xi2c";
  };
  "proxy-protocol-support" = fetchurl {
    url = "https://cdn.modrinth.com/data/mfONdVnp/versions/ULyNKtAz/proxy-protocol-support-1.2.1-fabric.jar";
    sha512 = "1p5bvlw01wfqfwf32b3jvp05f5bfz91sahczy9g2ykwhlzkxs74rzkj20bbhbrnk13qj5jpis31y60pr8haf0j42bz75233wganf0m1";
  };
  "easy-auth" = fetchurl {
    url = "https://cdn.modrinth.com/data/aZj58GfX/versions/Qd0CWVQP/easyauth-mc26.3-3.4.4.jar";
    sha512 = "2mvwc08lngys0dvd0cwgyvfp6ydbj0d3gzz1nqndv48j46ygifgmxxcfr48hwygnchk5bv9gmpsxcjkpmsg8lq0n4kn9r5xdpl3p6l4";
  };
}
