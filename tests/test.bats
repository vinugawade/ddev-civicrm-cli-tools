setup() {
  set -eu -o pipefail
  initialize_environment
  cleanup_project
  prepare_test_data
  start_ddev_environment
  install_cli_tools
}

initialize_environment() {
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/ddev-civicrm-cli-tools
  export PROJNAME=ddev-civicrm-cli-tools
  export DDEV_NONINTERACTIVE=true
  mkdir -p $TESTDIR
}

cleanup_project() {
  echo "🗑️  Deleting existing project if any..." >&3
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
}

prepare_test_data() {
  echo "📂 Copying test data to ${TESTDIR}..." >&3
  cp -r ${DIR}/tests/testdata/. ${TESTDIR}/
  cd "${TESTDIR}"
}

start_ddev_environment() {
  echo "🚀 Starting ddev environment..." >&3
  ddev start -y >/dev/null
}

install_cli_tools() {
  echo "📦 Installing 'civicrm/cli-tools' with no interaction..." >&3
  ddev composer require 'civicrm/cli-tools' --no-interaction --no-progress --prefer-dist
}

check_binary() {
  local binary=$1
  local alias=$2

  simulate_binary_removal "$binary"

  echo "🔄 Checking ddev $binary version using alias..." >&3
  if ! ddev "$alias" --version; then
    echo "❌ ddev $binary failed" >&3
    exit 1
  fi
}

simulate_binary_removal() {
  local binary=$1

  mv "./vendor/bin/$binary" "./vendor/bin/$binary-removed"
  echo "🔄 Checking if $binary command is available..." >&3
  if ddev exec command -v "$binary" >/dev/null; then
    echo "❌ $binary is still available but should have been removed!" >&3
    restore_binary "$binary"
    exit 1
  fi
  restore_binary "$binary"
}

restore_binary() {
  local binary=$1
  mv "./vendor/bin/$binary-removed" "./vendor/bin/$binary"
}

health_checks() {
  set -eu -o pipefail

  check_binary "cv" "cv"
  check_binary "civix" "cvx"
  check_binary "civistrings" "cvstr"
  check_binary "coworker" "cowkr"

  echo "✅ All health checks passed successfully!" >&3
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "❌ Unable to change directory to ${TESTDIR}\n" >&3 && exit 1 )

  echo "🧹 Cleaning up..." >&3
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory 📂" {
  set -eu -o pipefail
  cd ${TESTDIR}
  echo "⬇️  ddev add-on get ${DIR}" >&3
  ddev add-on get ${DIR}
  ddev restart
  health_checks
  ddev add-on remove ${DIR}
}

@test "install from release 🚀" {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "❌ Unable to cd to ${TESTDIR}\n" >&3 && exit 1 )
  echo "⬇️  ddev add-on get vinugawade/ddev-civicrm-cli-tools" >&3
  ddev add-on get vinugawade/ddev-civicrm-cli-tools
  ddev restart >/dev/null
  health_checks
  ddev add-on remove vinugawade/ddev-civicrm-cli-tools
}
