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

health_checks() {
  set -eu -o pipefail

  # Check ddev cv version
  echo "🔄 Checking ddev cv version using alias..." >&3
  if ! ddev cv --version; then
    echo "❌ ddev cv failed" >&3
    exit 1
  fi

  # Simulate renaming the cv command to cv-removed
  mv ./vendor/bin/cv ./vendor/bin/cv-removed
  echo "🔄 Checking if cv command is available..." >&3
  if ddev exec command -v cv >/dev/null; then
    echo "❌ cv is still available but should have been removed!" >&3
    # Restore cv
    mv ./vendor/bin/cv-removed ./vendor/bin/cv
    exit 1
  fi
  # Restore cv
  mv ./vendor/bin/cv-removed ./vendor/bin/cv

  # Check ddev civix version
  echo "🔄 Checking ddev civix version using alias..." >&3
  if ! ddev cvx --version; then
    echo "❌ ddev civix failed" >&3
    exit 1
  fi

  # Simulate renaming civix to civix-removed
  mv ./vendor/bin/civix ./vendor/bin/civix-removed
  echo "🔄 Checking if civix command is available..." >&3
  if ddev exec command -v civix >/dev/null; then
    echo "❌ civix is still available but should have been removed!" >&3
    # Restore civix
    mv ./vendor/bin/civix-removed ./vendor/bin/civix
    exit 1
  fi
  # Restore civix
  mv ./vendor/bin/civix-removed ./vendor/bin/civix

  # Check ddev civistrings version
  echo "🔄 Checking ddev civistrings version using alias..." >&3
  if ! ddev cvstr --version; then
    echo "❌ ddev civistrings failed" >&3
    exit 1
  fi

  # Simulate renaming civistrings to civistrings-removed
  mv ./vendor/bin/civistrings ./vendor/bin/civistrings-removed
  echo "🔄 Checking if civistrings command is available..." >&3
  if ddev exec command -v civistrings >/dev/null; then
    echo "❌ civistrings is still available but should have been removed!" >&3
    # Restore civistrings
    mv ./vendor/bin/civistrings-removed ./vendor/bin/civistrings
    exit 1
  fi
  # Restore civistrings
  mv ./vendor/bin/civistrings-removed ./vendor/bin/civistrings

  # Check ddev coworker version
  echo "🔄 Checking ddev coworker version using alias..." >&3
  if ! ddev cowkr --version; then
    echo "❌ ddev coworker failed" >&3
    exit 1
  fi

  # Simulate renaming coworker to coworker-removed
  mv ./vendor/bin/coworker ./vendor/bin/coworker-removed
  echo "🔄 Checking if coworker command is available..." >&3
  if ddev exec command -v coworker >/dev/null; then
    echo "❌ coworker is still available but should have been removed!" >&3
    # Restore coworker
    mv ./vendor/bin/coworker-removed ./vendor/bin/coworker
    exit 1
  fi
  # Restore coworker
  mv ./vendor/bin/coworker-removed ./vendor/bin/coworker

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
