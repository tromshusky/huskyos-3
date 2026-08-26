{
  inputs.nixpkgs.url = github:NixOS/nixpkgs/nixos-26.05;
  inputs.huskyos.url = github:tromshusky/huskyos-3;
  inputs.huskyos.inputs.nixpkgs.follows = "nixpkgs";
  outputs = { huskyos, self, ... }: huskyos.withSelf self;
}
