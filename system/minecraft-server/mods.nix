{ pkgs }:
with pkgs; {
  "fabric-api" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/P7dR8mSH/versions/lxeiLRwe/fabric-api-0.136.0%2B1.21.10.jar";
    sha512 =
      "2si04r7adzd9v26b49knwv41f8lz33bm1q67dhylic2m9dxprxbvy2d70cxj134arqlm0a8lw9vrys1hky912clgbhxpikxnpz5mbfn";
  };
  "distant-horizons" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/uCdwusMi/versions/9Y10ZuWP/DistantHorizons-2.3.6-b-1.21.10-fabric-neoforge.jar";
    sha512 =
      "3ya2x30aickp5iypr0rrbh1gj2smwbg49mcgp41cj6ijxlnhxcx4z17xynzv8xbj5pbaqf50zs9ay7ad0p3zyprlm9d3432xjvp06qv";
  };
  "skin-restorer" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/ghrZDhGW/versions/MKWfnXfO/skinrestorer-2.4.3+1.21.9-fabric.jar";
    sha512 =
      "32nfdpgyd00dvwis915k0x5z36jz8yymzk61ir7hq4zrwwffg8yk8xclhd712shhz5dp05zpy5cnyhk88x0lrj28s1qhyvhcws16xx3";
  };
  "lithium" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/gvQqBUqZ/versions/oGKQMdyZ/lithium-fabric-0.20.0+mc1.21.10.jar";
    sha512 =
      "393wcqdscp9dhpjnklacfvr8rcpzs17q4py6ap7igx8k8126ysmvn7h0inksg1a9ia2rp3bipyyrrnws4in1k1nv728mwznqw7hwp3m";
  };
  "very-many-players" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/wnEe9KBa/versions/ppncuwIK/vmp-fabric-mc1.21.10-0.2.0+beta.7.215-all.jar";
    sha512 =
      "1cxyc18yga2vvich0pgfll0rc01rw5knlyr1cr7wmpgkmdd9bmf11ldpzq7w7rpc4si4h2nfpdfax3qz11mamhk85mzs77flb3jd02c";
  };
  "spark" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/l6YH9Als/versions/eqIoLvsF/spark-1.10.152-fabric.jar";
    sha512 =
      "1wxc10n6hgwdn1qfy19swnzhpz7h4pwjx53kgkpl5vgsb157l9365pagw9zivlbnrxhbiwbs65d0j8nbgsfhlkzaib8gnsb3vwrb4pr";
  };
  "vanish" = fetchurl {
    url =
      "https://cdn.modrinth.com/data/UL4bJFDY/versions/lyeuEsAD/vanish-1.6.1+1.21.10.jar";
    sha512 =
      "2np50kafqa641r488iidig8fnnpwwzf85zv01s8cqhll0s40v212y6w181r85rxr75y0cg158slzbq74ddpindl4q8010dgm1v08q2b";
  };
}
