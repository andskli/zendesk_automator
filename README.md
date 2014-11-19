# zendesk_automator

Simple, scheduled creation (for starters at least) of tickets in ZenDesk.

## Description

zendesk-automator is a simple utility that reads a YAML config file, then schedules and executes ticket creation based upon the given input.

## Installation

## Usage

```
$ zendesk-automator -h
ZendeskAutomator 0.0.1 -- a convienient way of automating ticket
creation in Zendesk.

    -h, --help                       Display this screen
    -c, --config CONFIGFILE          Mandatory path to config file
    -t, --test                       Dry-run, does not do any actual ticket creation
```

## TODO

- [ ] Tests
- [ ] Daemonize
- [ ] Better logging
