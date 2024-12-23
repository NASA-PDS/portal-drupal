#!/bin/bash
#
# 🌞 Initialize Solr for PDS Portal with a "PDS" core.
#
# This is essentially the `solr-precreate` except it doesn't actually start
# Solr.
#
# 👉 N.B.: This must be run with bash, not sh, as it "sources" run-initdb, which
# uses fancy bash syntax.
#
# Why Solr itself doesn't provide this is odd: you'd normally want to make
# derived images that have your app-specific cores and configuration "baked
# in" 🤔
#
#
# Initialize the initialization
# -----------------------------
#
# Get any /docker-entrypoint-initdb.d scripts loaded.

. /opt/docker-solr/scripts/run-initdb


# PDS Core
# --------
#
# Make the PDS core.

exec /opt/docker-solr/scripts/precreate-core PDS
