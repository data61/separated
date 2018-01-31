{ mkDerivation, base, bifunctors, deriving-compat, directory
, doctest, filepath, lens, parsec, QuickCheck, semigroupoids
, semigroups, stdenv, template-haskell
}:
mkDerivation {
  pname = "separated";
  version = "0.3.1";
  src = ./.;
  libraryHaskellDepends = [
    base bifunctors deriving-compat lens semigroupoids semigroups
  ];
  testHaskellDepends = [
    base directory doctest filepath parsec QuickCheck template-haskell
  ];
  homepage = "https://github.com/qfpl/separated";
  description = "A data type with elements separated by values";
  license = stdenv.lib.licenses.bsd3;
}
