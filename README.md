[![add-on registry](https://img.shields.io/badge/DDEV-Add--on_Registry-blue)](https://addons.ddev.com/addons/vinugawade/ddev-civicrm-cli-tools)
[![tests](https://github.com/vinugawade/ddev-civicrm-cli-tools/actions/workflows/tests.yml/badge.svg?branch=main)](https://github.com/vinugawade/ddev-civicrm-cli-tools/actions/workflows/tests.yml?query=branch%3Amain)
[![last commit](https://img.shields.io/github/last-commit/vinugawade/ddev-civicrm-cli-tools)](https://github.com/vinugawade/ddev-civicrm-cli-tools/commits)
[![release](https://img.shields.io/github/v/release/vinugawade/ddev-civicrm-cli-tools)](https://github.com/vinugawade/ddev-civicrm-cli-tools/releases/latest)

# DDEV CiviCRM CLI Tools Add-on

This DDEV add-on provides project commands for the CiviCRM CLI tools distributed by [`civicrm/cli-tools`](https://github.com/civicrm/civicrm-cli-tools):

- `cv` for CiviCRM administration and development tasks
- `civix` for CiviCRM extension development
- `civistrings` for extracting translatable strings
- `coworker` for running background jobs

The add-on installs lightweight DDEV command wrappers. It does not install CiviCRM or the CLI tools package itself.

## Features

- Run the CiviCRM tools through consistent `ddev` commands.
- Use short aliases for `civix`, `civistrings`, and `coworker`.
- Get a clear error when `civicrm/cli-tools` is unavailable.
- Test the add-on against both stable DDEV and DDEV HEAD.
- Use the wrappers in Composer-based CiviCRM projects. The underlying tools retain their own CMS and bootstrap requirements.

## Requirements

- DDEV v1.24.10 or newer
- Composer available in the DDEV web container
- A Composer-based project in which `civicrm/cli-tools` can be installed
- A working CiviCRM installation for commands that need to bootstrap CiviCRM

## Installation

Install the add-on from the DDEV Add-on Registry:

```bash
ddev add-on get vinugawade/ddev-civicrm-cli-tools
ddev restart
```

Install the real CiviCRM CLI tools in the project:

```bash
ddev composer require civicrm/cli-tools
```

Verify the installation:

```bash
ddev cv --version
ddev civix --version
ddev civistrings --version
ddev coworker --version
```

Commit the resulting `.ddev` changes and the Composer changes according to your project's dependency policy.

## Usage

| DDEV command | Alias | Purpose |
| --- | --- | --- |
| `ddev cv` | `ddev cv` | Run the `cv` command |
| `ddev civix` | `ddev cvx` | Run the `civix` command |
| `ddev civistrings` | `ddev cvstr` | Run the `civistrings` command |
| `ddev coworker` | `ddev cowkr` | Run the `coworker` command |

### `cv`

```bash
ddev cv status
ddev cv flush
ddev cv updb
ddev cv api4 Contact.get +l 1
```

### `civix`

```bash
ddev civix build:zip
ddev civix upgrade
ddev cvx --version
```

### `civistrings`

```bash
ddev civistrings -o my-extension.pot path/to/extension
ddev cvstr --version
```

### `coworker`

```bash
ddev coworker list
ddev coworker debug
ddev cowkr --version
```

## Troubleshooting

When a wrapper reports that a command is unavailable, confirm that the package and Composer binaries exist:

```bash
ddev composer show civicrm/cli-tools
ddev exec ls -la vendor/bin/cv vendor/bin/civix vendor/bin/civistrings vendor/bin/coworker
```

Then reinstall dependencies if required:

```bash
ddev composer install
ddev restart
```

A successful `--version` check verifies the CLI binary and DDEV wrapper. Commands such as `cv status`, `cv flush`, and `cv updb` additionally require a valid CiviCRM installation that `cv` can bootstrap.

## Testing

The BATS suite installs the real `civicrm/cli-tools` package, installs the add-on, verifies every primary command and alias, and checks the missing-binary error behavior. It does not use fake fallback binaries.

Install `bats-core`, `bats-assert`, `bats-file`, and `bats-support`, then run from the repository root:

```bash
bats ./tests/test.bats
```

Exclude the released-add-on test during local development:

```bash
bats ./tests/test.bats --filter-tags '!release'
```

Check alignment with the current DDEV add-on template:

```bash
curl -fsSL https://ddev.com/s/addon-update-checker.sh | bash
```

## Repository structure

```text
.
├── .github
│   ├── ISSUE_TEMPLATE
│   ├── PULL_REQUEST_TEMPLATE.md
│   └── workflows/tests.yml
├── commands/web
│   ├── civistrings
│   ├── civix
│   ├── coworker
│   └── cv
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

Contributions are welcome. Create a branch, add or update tests for behavioral changes, run the BATS suite and update checker, and open a pull request.

## Maintainer

**Vinay Gawade**

- [GitHub](https://github.com/vinugawade)
- [Drupal](https://www.drupal.org/u/vinaygawade)
- [LinkedIn](https://www.linkedin.com/in/vinu-gawade)

## Acknowledgments

Thanks to the CiviCRM and DDEV communities for maintaining the underlying tools, documentation, and add-on ecosystem.
