#!/bin/sh -x
# Usage: $0 <nixpkgs | _nopkg> <osctl | osctld> <build id>

set -e

PKGS="$1"
GEMDIR="$2"
GEM="$(basename $2)"

export OS_BUILD_ID="$3"

pushd "$GEMDIR"
[ -f Gemfile.lock ] && rm -f Gemfile.lock
bundle install
pkg=$(bundle exec rake build | grep -oP "pkg/.+\.gem")
version=$(echo $pkg | grep -oP "\d+\.\d+\.\d+\.build\d+")

gem inabox -g "$GEMINABOX_URL" "$pkg"

[ "$PKGS" == "_nopkg" ] && exit

popd
pushd "$PKGS/$GEM"
rm -f Gemfile.lock gemset.nix
cat <<EOF > Gemfile
source '$GEMINABOX_URL'
gem '$GEM', '$version'
EOF

[ -f Gemfile.tail ] && cat Gemfile.tail >> Gemfile

bundix -l

popd
pushd os
nix-build --attr "$GEM" --no-out-link packages.nix
