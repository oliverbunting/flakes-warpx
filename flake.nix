{
  description = "AMReX is a software framework designed to accelerate scientific discovery for applications solving partial differential equations on block-structured meshes";

  inputs = {
    amrex-src = {
      url = github:AMReX-Codes/amrex/development;
      flake = false;
    };
    
    picsar-src = {
      url = github:ECP-WarpX/picsar;
      flake = false;
    };
    
    openpmd-api-src = {
      url = github:openPMD/openPMD-api;
      flake = false;
    };

    WarpX-src = {
      url = github:ECP-WarpX/WarpX;
      flake = false;
    };
    
    nixpkgs.url = github:NixOS/nixpkgs/nixos-23.05;
  };

  outputs = { self, nixpkgs, ... }@inputs: {

    packages.x86_64-linux.amrex = 
      with import nixpkgs { system = "x86_64-linux"; };
    
      stdenv.mkDerivation {
        name = "WarpX";
        srcs = [ inputs.amrex-src inputs.picsar-src inputs.WarpX-src ];
	unpackPhase = ''
	  cp -r ${inputs.amrex-src} amrex;
	  cp -r ${inputs.openpmd-api-src} openpmd-api;
	  cp -r ${inputs.picsar-src} picsar;
	  cp -r ${inputs.WarpX-src} WarpX;
	  chmod -R u+w .
	'';
        sourceRoot = "WarpX";
	nativeBuildInputs = [ cmake ];
	buildInputs = [ openmpi ];
	cmakeFlags = [
	  "-DWarpX_amrex_src=../../amrex"
	  "-DWarpX_openpmd_src=../../openpmd-api"
	  "-DWarpX_picsar_src=../../picsar"
	];
      };

    packages.x86_64-linux.default = self.packages.x86_64-linux.amrex;

  };
}
