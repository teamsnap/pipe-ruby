#!/usr/bin/env bash

set -e

cp infra/docker/scripts/.bashrc ~/.bashrc

exec "$@"
