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
  "c2me" = fetchurl {
    url = "https://cdn.modrinth.com/data/VSNURh3q/versions/ODMLK8M9/c2me-fabric-mc26.3-0.4.2-alpha.0.90.jar";
    sha512 = "37c58cys5ysjjv42mz1w04vsf1ibrkk2dwgqr7r4q7xgi4z3c0x2rxwagxbmnnfk3ph0044c9snck95pdfnh5sf5h0fxdr2mnyhw56h";
  };
  "scalablelux" = fetchurl {
    url = "https://cdn.modrinth.com/data/Ps1zyz6x/versions/g4eqNSKd/ScalableLux-fabric-mc26.3-0.3.0-alpha.0.6-all.jar";
    sha512 = "34wqs8mmp2kzxs3zf7d31qs2igg4qjfdbf9ix77k7xxpj2fk4i9b016nrkxbirrz5nz3pr8pcypfl40p6lpq51vyg0q3ar0zcwskmfy";
  };
  "spark" = fetchurl {
    url = "https://cdn.modrinth.com/data/l6YH9Als/versions/e3hsPc1o/spark-1.10.187-fabric.jar";
    sha512 = "2a3iag9ns7w8qi7cj04xhyn1nxd39xk8h1ppws1z484ahwdhw8lm77rybk2fnmzly8izs8mh0m2fas1av3yl5x7dvn4a93bl7azajy7";
  };
  "servux" = fetchurl {
    url = "https://cdn.modrinth.com/data/zQhsx8KF/versions/azA4UG3T/servux-fabric-26.3-0.12.2.jar";
    sha512 = "2y0h0i8q0lkg17sxwr193g2ffb4gn76v38s2gr0g5pv3b1rs88qp3sk3i1jw4pl59l7j58fl9y8q8dzysa3rz5xgxwb40hmqrqh6qza";
  };
  "fabric-language-kotlin" = fetchurl {
    url = "https://cdn.modrinth.com/data/Ha28R6CL/versions/SKW1BTL3/fabric-language-kotlin-1.14.2%2Bkotlin.2.4.21.jar";
    sha512 = "1fpwh793mabxcnj9rfx8fkc68ilaqkinf0c23j9r67d01sziciz87hryzxlvwwc7vggpcfm8cacam53b257kdd4mk8gigg7lz27bd3z";
  };
  "ledger" = fetchurl {
    url = "https://cdn.modrinth.com/data/LVN9ygNV/versions/pxv5cN0d/ledger-1.3.25.jar";
    sha512 = "14jv37clwnsshd15y6ki3mrlp49abskmpimvliifr283bylgp5xah4vdn2shh0wiqkl9fyvardma4xaj846mwlrz2nxs9d2imr48bpk";
  };
  "ledger-databases" = fetchurl {
    url = "https://cdn.modrinth.com/data/qo9qFPdi/versions/kF6IfYxY/ledger-databases-1.2.2.jar";
    sha512 = "0lpfxvcrkxpdwc9fl26hqmhv7qsg47qiiaxg5aqvmi505d0clgbbps1zkj42h9yj77hyahfz213cn09sadmvgiy16mizhfp9cxrq3m8";
  };
  "server-replay" = fetchurl {
    url = "https://cdn.modrinth.com/data/qCvSZ8ra/versions/rCmC09FF/ServerReplay-3.6.0-beta.5%2B26.3.jar";
    sha512 = "2c8rpdz31qmnk9nibjsn52v5szhcbdskhdya2qbw8m2qlyxbddh1v0zggw1igi9h3f9b82kvyamds1lr7lfijksic4dv5apzy27b1gy";
  };
  "fabricexporter" = fetchurl {
    url = "https://cdn.modrinth.com/data/dbVXHSlv/versions/tuPsGk8g/fabricexporter-26.2-1.0.22.jar";
    sha512 = "1q0hxjjp20mh5pihm5a5girmkjmq2zfxaijxvxy2ysmr1676pm8ia06jqs8zghx3hzvg5igxdsa8svp37fx1wbzfwp1s34hi71mqiw0";
  };
}
