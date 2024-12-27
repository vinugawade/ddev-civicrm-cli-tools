setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/civicrm-cli-tools
  mkdir -p $TESTDIR
  export PROJNAME=civicrm-cli-tools
  export DDEV_NONINTERACTIVE=true

  # Delete any existing project instance quietly
  echo "🗑️  Deleting existing project if any..." >&3
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true

  # Copy all files including hidden files from tests/testdata to TESTDIR
  echo "📂 Copying test data to ${TESTDIR}..." >&3
  cp -r ${DIR}/tests/testdata/. ${TESTDIR}/
  cd "${TESTDIR}"

  # Start ddev and install composer dependencies
  echo "🚀 Starting ddev environment..." >&3
  ddev start -y >/dev/null
  # Run composer require for cli-tools with no interaction
  echo "📦 Installing 'civicrm/cli-tools' with no interaction..." >&3
  ddev composer require 'civicrm/cli-tools' --no-interaction --no-progress --prefer-dist
}

# A reusable function to test a binary's availability
check_binary() {
  local binary=$1
  local alias=$2

  echo "🔄 Checking ddev $binary version using alias..." >&3
  if ! ddev "$alias" --version; then
    echo "❌ ddev $binary failed" >&3
    exit 1
  fi

  # Simulate renaming the binary to ensure the alias resolves correctly
  mv "./vendor/bin/$binary" "./vendor/bin/$binary-removed"
  echo "🔄 Checking if $binary command is available..." >&3
  if ddev exec command -v "$binary" >/dev/null; then
    echo "❌ $binary is still available but should have been removed!" >&3
    # Restore binary
    mv "./vendor/bin/$binary-removed" "./vendor/bin/$binary"
    exit 1
  fi
  # Restore binary
  mv "./vendor/bin/$binary-removed" "./vendor/bin/$binary"
}

health_checks() {
  set -eu -o pipefail

  # Perform binary checks for all required binaries
  check_binary "cv" "cv"
  check_binary "civix" "cvx"
  check_binary "civistrings" "cvstr"
  check_binary "coworker" "cowkr"

  # All checks passed, print a success message
  echo "✅ All health checks passed successfully!" >&3
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "❌ Unable to change directory to ${TESTDIR}\n" >&3 && exit 1 )

  # Clean up and delete the project if it exists
  echo "🧹 Cleaning up..." >&3
  # Clear composer cache and delete the project
  ddev composer cc
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory 📂" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "⬇️  ddev add-on get ${DIR}" >&3
  ddev add-on get ${DIR}
  ddev restart
  # Run health checks and capture output to BATS_OUT for full visibility
  health_checks
  ddev add-on remove ${DIR}
}

@test "install from release 🚀" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "❌ Unable to cd to ${TESTDIR}\n" >&3 && exit 1 )
  echo "⬇️  ddev add-on get ${DIR}" >&3
  ddev add-on get vinugawade/civicrm-cli-tools
  ddev restart >/dev/null
  health_checks
  ddev add-on remove vinugawade/civicrm-cli-tools
}
