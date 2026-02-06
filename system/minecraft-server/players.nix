let
  mkPlayer = name: offlineUuid: onlineUuid: level: bypassesPlayerLimit: {
    inherit
      name
      offlineUuid
      onlineUuid
      level
      bypassesPlayerLimit
      ;
  };

  list = [
    (mkPlayer "andrewyazura" "c2eb76fe-7bea-3498-b396-066ba66e08ae"
      "2629aa63-faec-4548-bdc0-260850cf3cbf"
      4
      false
    )
    (mkPlayer "boober" "ecff3058-99c4-3f02-b7e5-154740f59632" "ea38893c-11c9-493d-a285-69916f41f03f" 4
      false
    )
    (mkPlayer "chief" "adfadefe-d090-35d2-b71e-b7ed34dfca93" "5aa86e15-6ddd-404e-93bf-71a87f448abc" 0
      false
    )
    (mkPlayer "Singualrity" "72271d99-4491-320e-8c32-bf4791c3f384"
      "d2988641-9838-4fcd-ba0c-0b263205563a"
      0
      false
    )
    (mkPlayer "Sliparick" "6def2816-d21e-35fa-bb5c-e989bed75acb" "fec0904f-37d5-4e9f-8edc-55c3ed9cdfdf"
      0
      false
    )
    (mkPlayer "War_of_Lord" "844cb079-11a2-3d18-bc9b-b15a7e1f1751"
      "3da44920-a9d9-4925-b39c-5d47dfc6051e"
      0
      false
    )
    (mkPlayer "Prorab_Vitya" "e53b149e-f0c2-3ff5-94eb-2980d2d63ea2"
      "3daa0578-ab59-406e-9d8c-baf24cbe9bdc"
      0
      false
    )
    (mkPlayer "Fannera" "6507a34d-c795-3211-8a0c-61732ad90b96" "47803ac2-9f82-4c7c-bb6b-d5536eaca3e9" 0
      false
    )
    (mkPlayer "Raidzin" "1115c914-a480-35ae-829b-3d70a17aa436" "336f30af-8c87-4447-809b-af5ea7d2abbc" 0
      false
    )
    (mkPlayer "yanachlene" "30274c65-a264-3bdd-9fea-70d9aaa476e9" "b1ec34f2-d4a3-42df-88f6-22709bb87ad7"
      0
      false
    )
    (mkPlayer "Be4Frosty2000" "531aaad4-1963-36a2-bf83-0e30035fef16"
      "fe672f07-8fd4-400d-850c-09ce54b010d4"
      0
      false
    )
    (mkPlayer "marrianss" "224f0912-1fa3-3d2e-975a-a80afe906913" "68af9b18-9bdb-468f-af01-27d684a16750"
      0
      false
    )
    (mkPlayer "GameMax" "e249f570-bf3b-3ff3-aa8a-12a5909698ca" "c0f697f2-8300-4725-ab4e-9de702b5fc21" 0
      false
    ) # TODO: delete
  ];
in
{
  inherit list;

  online = map (p: {
    inherit (p) name level bypassesPlayerLimit;
    uuid = p.onlineUuid;
  }) list;

  offline = map (p: {
    inherit (p) name level bypassesPlayerLimit;
    uuid = p.offlineUuid;
  }) list;

  toWhitelist =
    players:
    builtins.listToAttrs (
      map (p: {
        name = p.name;
        value = p.uuid;
      }) players
    );

  toOperators =
    players:
    builtins.listToAttrs (
      map (p: {
        name = p.name;
        value = removeAttrs p [ "name" ];
      }) (builtins.filter (p: p.level > 0) players)
    );
}
