{ lib, stdenv, fetchurl, fetchpatch, pkgconfig, libusb1, libyubikey, json_c }:

stdenv.mkDerivation rec {
  pname = "yubikey-personalization";
  version = "1.20.0";

  src = fetchurl {
    url = "https://developers.yubico.com/yubikey-personalization/Releases/ykpers-${version}.tar.gz";
    sha256 = "14wvlwqnwj0gllkpvfqiy8ns938bwvjsz8x1hmymmx32m074vj0f";
  };

  patches = [
    # remove after updating to next release
    (fetchpatch {
      name = "json-c-0.14-support.patch";
      url = "https://github.com/Yubico/yubikey-personalization/commit/0aa2e2cae2e1777863993a10c809bb50f4cde7f8.patch";
      sha256 = "1wnigf3hbq59i15kgxpq3pwrl1drpbj134x81mmv9xm1r44cjva8";
    })
  ];

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ libusb1 libyubikey json_c ];

  configureFlags = [
    "--with-backend=libusb-1.0"
  ];

  doCheck = true;

  postInstall = ''
    # Don't use 70-yubikey.rules because it depends on ConsoleKit
    install -D -t $out/lib/udev/rules.d 69-yubikey.rules
  '';

  meta = with lib; {
    homepage = "https://developers.yubico.com/yubikey-personalization";
    description = "A library and command line tool to personalize YubiKeys";
    license = licenses.bsd2;
    platforms = platforms.unix;
  };
}
