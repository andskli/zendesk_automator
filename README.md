# zendesk_automator

Simple, scheduled creation (for starters at least) of tickets in ZenDesk.

## Description

zendesk-automator is a simple utility that reads a YAML config file, then schedules and executes ticket creation based upon the given input.

## Installation

## Usage

```
$ zendesk-automator -h
ZendeskAutomator 0.0.1 -- a convienient way of automating ticket
creation in Zendesk.

    -h, --help                       Display this screen
    -c, --config CONFIGFILE          Mandatory path to config file
    -t, --test                       Dry-run, does not do any actual ticket creation
```

Example YAML config file (notice erb date config..):

```yaml
---
zendesk:
  url: https://cookiefactorycompany.zendesk.com/api/v2
  username: user@cookiefactorycompany.com
  token: magic zendesk token

schedules:
  daily_0500:
    cron: 0 5 * * 1,2,3,4,5

tasks:
  check_the_ovens:
    schedule: daily_0500
    subject: <%= Time::new.strftime("%Y-%m-%d") %> Check that ovens are clean
    comment: |
      Perform the daily oven checking
      In order for proper cookie baking, ovens needs to be clean, plz check.
    submitter_id: 1337  # id of the submitting user in zendesk
    requester_id: 1337  # id of the requesting user in zendesk
    type: task  # Could be task/problem etc
    priority: high
    tags:
      - oven
      - cleaning
```

## TODO

- [ ] Tests
- [ ] Daemonize
- [ ] Better logging
- [x] Templating


## Contribute

zendesk_automator came out of the idea that automatically creating tickets in zendesk should be simple to configure and setup, according to the needs that I saw. Thus, the current implementation is quite specific to these needs. Improvements surely can be done and all contributions are welcome, even complete re-thinking/structuring of things.
