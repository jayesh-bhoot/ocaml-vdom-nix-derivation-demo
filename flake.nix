{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    ocamlVdomChan.url = "github:jayesh-bhoot/nixpkgs/ocaml-vdom";
  };

  outputs = { self, nixpkgs, ocamlVdomChan }:
    let
      systems = [ "x86_64-darwin" "aarch64-darwin" "x86_64-linux" ];
      createDevShell = system:
        let
          pkgs = import nixpkgs { inherit system; };
        in
        let
          ocamlVdomChanPkgs = import ocamlVdomChan { inherit system; };
        in
        pkgs.mkShell {
          buildInputs = with pkgs; [
            ocaml
            ocamlPackages.findlib
            dune_3
            ocamlPackages.ocaml-lsp
            ocamlformat
            ocamlPackages.ocamlformat-rpc-lib
            ocamlPackages.utop

            ocamlVdomChanPkgs.ocamlPackages.ocaml-vdom

            nodejs
            nodePackages.web-ext
          ];
        };
    in
    {
      devShell = nixpkgs.lib.genAttrs systems createDevShell;
    };
}
