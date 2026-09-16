{ pkgs }:
with pkgs;
{
  "fabric-api" = fetchurl {
    url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/BQfN2OGk/fabric-api-0.160.6%2B26.3.jar";
    sha512 = "0c6srq17vmlacyg1d63154bi2zshy36by6ngmq6c9gdmmkjabk71w3nz4jxynra892z507nd386q6033nkgz8lnqrgi3fs4rs0b2dc7";
  };
  "skin-restorer" = fetchurl {
    url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/rPmMM0mv/skinrestorer-2.11.0%2B26.1-fabric.jar";
    sha512 = "38iilm0s6b88j7xs3lxd5vq78pm0c2d4lmr16plgsjlxyx2rjm88aamb0a6g5bs4axlpagkg6kq6mriqv29k6byrsncr29g2585axlr";
  };
  "lithium" = fetchurl {
    url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/WXHRsMRl/lithium-fabric-0.26.1%2Bmc26.3.jar";
    sha512 = "1crqr1z83p23r0a1i46di0sw1qbpg8dbf9hj53ys9vhv3rgnpn029cscccvj4lah1j7dljspd53h6b0hvcz22x20dg00gr0g81rpfxc";
  };
  "vanish" = fetchurl {
    url = "https://cdn.modrinth.com/data/UL4bJFDY/versions/QGY1aFDb/vanish-1.6.15%2B26.2.jar";
    sha512 = "2g9dbyvagvgxvivjr3b5yy6xz1lv8xqrr710973bn9m2lksfws6y3fj2y5w9j7hr8h4v3gqdxiy84xbgchhxa9k6xfijxa5vsz2lf9r";
  };
  "proxy-protocol-support" = fetchurl {
    url = "https://cdn.modrinth.com/data/mfONdVnp/versions/ULyNKtAz/proxy-protocol-support-1.2.1-fabric.jar";
    sha512 = "1p5bvlw01wfqfwf32b3jvp05f5bfz91sahczy9g2ykwhlzkxs74rzkj20bbhbrnk13qj5jpis31y60pr8haf0j42bz75233wganf0m1";
  };
  "easy-auth" = fetchurl {
    url = "https://cdn.modrinth.com/data/aZj58GfX/versions/3d6BOvmm/easyauth-mc26.2-3.4.4.jar";
    sha512 = "1pfkk3knb05grwglaf8h8396cmk2bfdsay3nbljx94gvvfjv75qrl7z9mhfnvr0lfd9hngb270kjg60vb7np5wlmynz0l190mrbm0js";
  };
}
