{ pkgs }:
with pkgs;
{
  "fabric-api" = fetchurl {
    url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/yALY9gHM/fabric-api-0.151.0%2B26.1.2.jar";
    sha512 = "3fkqc6i51srfzy1p7339zg18hr64fa3kgnw7hpiw2m0dipzkgym1k94i6pdscz6bm1q7mzl91w56py7ggpzjj4jm15l2qmr8ac391yh";
  };
  "skin-restorer" = fetchurl {
    url = "https://cdn.modrinth.com/data/ghrZDhGW/versions/9MoU6vsD/skinrestorer-2.8.0%2B26.1-fabric.jar";
    sha512 = "0bfxbcn6a1jm1rk40j847xy210ad528acd7mymrarqk93vyl8fnnkprbcqb5hhbwvs4vyvm58k9yqqlxrbwgjp56hn9dyqcd8dg0hgr";
  };
  "lithium" = fetchurl {
    url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/GiCfpS6V/lithium-fabric-0.24.5%2Bmc26.1.2.jar";
    sha512 = "0vsv0pm0dcdj2fbds8jxg974qb15y7pdikclrbzgpipx63y5hzy4ag2c80phnnv6pjd6gy72s8py32q90nkvllp7fz7ckch5lsvscaw";
  };
  "vanish" = fetchurl {
    url = "https://cdn.modrinth.com/data/UL4bJFDY/versions/MAfndrvo/vanish-1.6.9%2B26.1.2.jar";
    sha512 = "1v3wyjfwdkx00dzyc01z2v0djkkk8r9yqjxswcc98ycw67n7x0y9fgvhsv1l8w901dkdx2v68ak8v75bbzp812wv1pqlznj9a0kqw7g";
  };
  "proxy-protocol-support" = fetchurl {
    url = "https://cdn.modrinth.com/data/mfONdVnp/versions/ULyNKtAz/proxy-protocol-support-1.2.1-fabric.jar";
    sha512 = "1p5bvlw01wfqfwf32b3jvp05f5bfz91sahczy9g2ykwhlzkxs74rzkj20bbhbrnk13qj5jpis31y60pr8haf0j42bz75233wganf0m1";
  };
  "easy-auth" = fetchurl {
    url = "https://cdn.modrinth.com/data/aZj58GfX/versions/h9nSM2ZF/easyauth-mc26.1-3.4.3-SNAPSHOT.48.jar";
    sha512 = "1rx1d55jskkhh3i8rxkkzzk8whrba2d6frjkckal29wd1c2hfk0s3pm4ckwlxdwq42xdrp3kvzpllrwaxn9vbr7p6lxwd10shm8j6hb";
  };
}
