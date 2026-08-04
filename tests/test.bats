#!/usr/bin/env bats

# Run from the add-on root with: bats ./tests/test.bats
# Exclude release tests with: bats ./tests/test.bats --filter-tags '!release'

export GITHUB_REPO=vinugawade/ddev-civicrm-cli-tools

TEST_BREW_PREFIX="$(brew --prefix 2>/dev/null || true)"
export BATS_LIB_PATH="${BATS_LIB_PATH:-}:${TEST_BREW_PREFIX}/lib:/usr/lib/bats"

bats_load_library bats-assert
bats_load_library bats-file
bats_load_library bats-support

export DIR="$(cd "$(dirname "${BATS_TEST_FILENAME}")/.." >/dev/null 2>&1 && pwd)"
export PROJNAME="test-$(basename "${GITHUB_REPO}")"

mkdir -p "${HOME}/tmp"
export TESTDIR="$(mktemp -d "${HOME}/tmp/${PROJNAME}.XXXXXX")"

export DDEV_NONINTERACTIVE=true
export DDEV_NO_INSTRUMENTATION=true
export BATS_TEST_TIMEOUT=900

run_ddev() {
  run ddev "$@" 3>&-
}

setup() {
  set -eu -o pipefail

  ddev delete -Oy "${PROJNAME}" 3>&- >/dev/null 2>&1 || true
  prepare_test_project
  start_ddev_project
  install_cli_tools
}

prepare_test_project() {
  rm -rf "${TESTDIR}"
  mkdir -p "${TESTDIR}"
  cp -R "${DIR}/tests/testdata/." "${TESTDIR}/"
  cd "${TESTDIR}"

  if [[ ! -f index.php && ! -f index.html ]]; then
    echo "<?php echo 'DDEV CiviCRM CLI Tools test project';" > index.php
  fi

  run_ddev config --project-name="${PROJNAME}" --project-tld=ddev.site
  assert_success
}

start_ddev_project() {
  run_ddev start -y
  assert_success
}

install_cli_tools() {
  local attempt=1
  local max_attempts=3

  while [[ "${attempt}" -le "${max_attempts}" ]]; do
    echo "Installing civicrm/cli-tools (${attempt}/${max_attempts})..." >&3

    run_ddev composer require civicrm/cli-tools --no-interaction --no-progress --prefer-dist
    if [[ "${status}" -eq 0 ]]; then
      return 0
    fi

    echo "${output}" >&3

    if [[ "${attempt}" -lt "${max_attempts}" ]]; then
      ddev composer clear-cache 3>&- >/dev/null 2>&1 || true
      sleep 5
    fi

    attempt=$((attempt + 1))
  done

  echo "Unable to install the real civicrm/cli-tools package after ${max_attempts} attempts." >&3
  return 1
}

assert_binary_installed() {
  local binary=$1

  run_ddev exec command -v "${binary}"
  assert_success
  assert_output --partial "vendor/bin/${binary}"
}

assert_cli_command() {
  local command_name=$1

  run_ddev "${command_name}" --version
  assert_success
  [[ -n "${output}" ]]
}

assert_missing_binary_error() {
  local binary=$1
  local command_name=$2
  local binary_path="${TESTDIR}/vendor/bin/${binary}"
  local removed_path="${binary_path}.removed"

  mv "${binary_path}" "${removed_path}"

  run_ddev "${command_name}" --version
  assert_failure
  assert_output --partial "${binary} is not available"

  mv "${removed_path}" "${binary_path}"
}

health_checks() {
  local binary
  local command_name

  for binary in cv civix civistrings coworker; do
    assert_binary_installed "${binary}"
  done

  for command_name in cv civix cvx civistrings cvstr coworker cowkr; do
    assert_cli_command "${command_name}"
  done

  assert_missing_binary_error cv cv
  assert_missing_binary_error civix civix
  assert_missing_binary_error civistrings civistrings
  assert_missing_binary_error coworker coworker
}

teardown() {
  set -eu -o pipefail

  if [[ -d "${TESTDIR}" ]]; then
    cd "${TESTDIR}" || true
    ddev delete -Oy "${PROJNAME}" 3>&- >/dev/null 2>&1 || true
  fi

  if [[ -n "${GITHUB_ENV:-}" ]]; then
    echo "TESTDIR=${TESTDIR}" >> "${GITHUB_ENV}"
  else
    rm -rf "${TESTDIR}"
  fi
}

@test "install from directory" {
  set -eu -o pipefail

  echo "Installing add-on from ${DIR}" >&3
  run_ddev add-on get "${DIR}"
  assert_success

  run_ddev restart -y
  assert_success

  health_checks
}

# bats test_tags=release
@test "install from release" {
  set -eu -o pipefail

  echo "Installing add-on from ${GITHUB_REPO}" >&3
  run_ddev add-on get "${GITHUB_REPO}"
  assert_success

  run_ddev restart -y
  assert_success

  health_checks
}
