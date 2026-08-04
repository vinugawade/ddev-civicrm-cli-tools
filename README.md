[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com/addons/vinugawade/ddev-civicrm-cli-tools)
[![tests](https://github.com/vinugawade/ddev-civicrm-cli-tools/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/vinugawade/ddev-civicrm-cli-tools/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/vinugawade/ddev-civicrm-cli-tools)](https://github.com/vinugawade/ddev-civicrm-cli-tools/commits)
[![release](https://img.shields.io/github/v/release/vinugawade/ddev-civicrm-cli-tools)](https://github.com/vinugawade/ddev-civicrm-cli-tools/releases/latest)

# DDEV CiviCRM CLI Tools Add-on

## Overview

This add-on provides project-level [DDEV web-container commands](https://docs.ddev.com/en/stable/users/extend/custom-commands/) for the CiviCRM command-line tools distributed by [`civicrm/cli-tools`](https://github.com/civicrm/civicrm-cli-tools).

| DDEV command | Alias | Tool | Purpose |
| --- | --- | --- | --- |
| `ddev cv` | — | `cv` | Administer, inspect, and develop a CiviCRM installation |
| `ddev civix` | `ddev cvx` | `civix` | Develop and maintain CiviCRM extensions |
| `ddev civistrings` | `ddev cvstr` | `civistrings` | Extract translatable strings into gettext templates |
| `ddev coworker` | `ddev cowkr` | `coworker` | Run and inspect CiviCRM worker processes |

The add-on installs lightweight command wrappers in the project's `.ddev` directory. It does not install CiviCRM or `civicrm/cli-tools` itself.

## Features

- Run the supported CiviCRM CLI tools through consistent `ddev` commands.
- Use short aliases for `civix`, `civistrings`, and `coworker`.
- Forward command arguments, output, signals, and exit codes to the underlying tools.
- Receive a clear error when a required `vendor/bin` executable is unavailable.
- Use project-local Composer dependencies instead of global CLI installations.
- Validate changes against stable DDEV, with DDEV HEAD retained as a scheduled/manual canary.

## Requirements

- DDEV v1.24.10 or newer
- A configured DDEV project
- Composer available in the DDEV web container
- A Composer-based project in which `civicrm/cli-tools` can be installed
- A working CiviCRM installation for commands that bootstrap CiviCRM

The wrappers are CMS-neutral. Actual CMS, PHP, and CiviCRM compatibility is determined by CiviCRM and the individual upstream CLI tools.

## Installation

Run these commands from the DDEV project root:

```bash
ddev add-on get vinugawade/ddev-civicrm-cli-tools
ddev restart
```

Install the CiviCRM CLI tools as a development dependency:

```bash
ddev composer require --dev civicrm/cli-tools
```

Omit `--dev` only when the project intentionally manages these tools as a regular production dependency.

Verify the installation:

```bash
ddev cv --version
ddev civix --version
ddev civistrings --version
ddev coworker --version
```

After installation, commit the generated `.ddev` files together with the appropriate Composer files according to the project's dependency policy:

```bash
git add .ddev composer.json composer.lock
```

### Install a specific add-on release

To install a specific release instead of the latest stable release:

```bash
ddev add-on get vinugawade/ddev-civicrm-cli-tools --version v1.0.2
ddev restart
```

## Updating

Update the add-on to its latest stable release:

```bash
ddev add-on get vinugawade/ddev-civicrm-cli-tools
ddev restart
```

The add-on and the Composer package are versioned independently. Update the CiviCRM CLI tools separately when required:

```bash
ddev composer update civicrm/cli-tools --with-dependencies
```

Review and commit the resulting `.ddev`, `composer.json`, and `composer.lock` changes.

## Listing and removing the add-on

List add-ons installed in the current project:

```bash
ddev add-on list --installed
```

Remove this add-on:

```bash
ddev add-on remove ddev-civicrm-cli-tools
ddev restart
```

Removing the add-on deletes its DDEV wrappers but does not automatically remove the Composer package. Remove that separately when it is no longer needed:

```bash
ddev composer remove civicrm/cli-tools
```

## Usage

Pass any supported upstream arguments after the DDEV command. Use `--help` to inspect the options provided by each tool.

### `cv`

```bash
ddev cv --help
ddev cv status
ddev cv flush
ddev cv updb
ddev cv api4 Contact.get +l 1
```

Commands such as `status`, `flush`, `updb`, and `api4` require `cv` to locate and bootstrap a valid CiviCRM installation.

### `civix`

```bash
ddev civix --help
ddev civix civicrm:ping
ddev civix build:zip
ddev cvx --version
```

Run extension-specific commands from an appropriate extension directory when required by `civix`.

### `civistrings`

```bash
ddev civistrings --help
ddev civistrings -o my-extension.pot path/to/extension
ddev cvstr --version
```

### `coworker`

```bash
ddev coworker --help
ddev coworker --version
ddev cowkr --version
```

## How it works

The add-on installs command scripts under `.ddev/commands/web`. DDEV executes these scripts inside the project's web container, where they call the corresponding executable from the project's Composer `vendor/bin` directory.

This keeps the tools project-specific and avoids relying on global host installations.

## Troubleshooting

### Confirm that the add-on is installed

```bash
ddev add-on list --installed
ddev restart
```

If installation or updating fails, rerun it with verbose output:

```bash
ddev add-on get vinugawade/ddev-civicrm-cli-tools --verbose
```

### Confirm that the Composer package and binaries exist

```bash
ddev composer show civicrm/cli-tools
ddev exec ls -la \
  vendor/bin/cv \
  vendor/bin/civix \
  vendor/bin/civistrings \
  vendor/bin/coworker
```

If the package is installed under `require-dev`, a Composer install using `--no-dev` will intentionally omit these binaries. Restore the local development dependencies with:

```bash
ddev composer install
ddev restart
```

### Separate wrapper problems from CiviCRM bootstrap problems

A successful version check confirms that the add-on wrapper can execute the installed CLI binary:

```bash
ddev cv --version
```

A command such as the following additionally verifies that `cv` can find and bootstrap CiviCRM:

```bash
ddev cv status
```

When `--version` succeeds but `status` fails, investigate the CiviCRM/CMS installation, document root, settings files, permissions, and upstream tool requirements rather than reinstalling the add-on.

## Development and testing

The BATS suite installs the real `civicrm/cli-tools` package, downloads the official tool PHARs, installs the add-on, verifies every primary command and alias, and tests missing-binary error handling. It does not use fake fallback binaries.

### Local test prerequisites

On macOS or Linux with Homebrew:

```bash
brew tap bats-core/bats-core
brew install \
  bats-core \
  bats-core/bats-core/bats-assert \
  bats-core/bats-core/bats-file \
  bats-core/bats-core/bats-support \
  jq
```

Run the current-directory add-on test during development:

```bash
bats ./tests/test.bats --filter-tags '!release'
```

Run the complete suite, including installation from the latest published release:

```bash
bats ./tests/test.bats
```

Check the repository against the current DDEV add-on template and maintenance rules:

```bash
ddev utility addon-update-checker
```

### Continuous integration

- Stable DDEV is the required test for pull requests and pushes to `main`.
- DDEV HEAD runs as a scheduled/manual, nonblocking canary with a bounded timeout.
- Release-tagged BATS coverage verifies installation from the published add-on release.

## Repository structure

```text
.
├── .github
│   ├── ISSUE_TEMPLATE
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows
│       └── tests.yml
├── commands
│   └── web
│       ├── civistrings
│       ├── civix
│       ├── coworker
│       └── cv
├── tests
│   ├── test.bats
│   └── testdata
├── .editorconfig
├── .gitattributes
├── install.yaml
├── LICENSE
└── README.md
```

## Contributing

Contributions are welcome.

- Create a focused branch.
- Add or update tests for behavioral changes.
- Run the focused BATS test, the complete suite when appropriate, and `ddev utility addon-update-checker`.
- Update documentation when command behavior or requirements change.
- Open a pull request with a clear summary and verification results.

## Maintainer

**Vinay Gawade**

- [GitHub](https://github.com/vinugawade)
- [Drupal](https://www.drupal.org/u/vinaygawade)
- [LinkedIn](https://www.linkedin.com/in/vinu-gawade)

## Acknowledgments

Thanks to the CiviCRM and DDEV communities for maintaining the underlying tools, documentation, testing infrastructure, and add-on ecosystem.
