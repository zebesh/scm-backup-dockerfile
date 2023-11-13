#!/usr/bin/env bash

yq e -i '(.sources[] | select(.title == "bitbucket_backup").name) = env(BITBUCKET_TEAM)' settings.yml
yq e -i '(.sources[] | select(.title == "bitbucket_backup").authName) = env(BITBUCKET_USER)' settings.yml
yq e -i '(.sources[] | select(.title == "bitbucket_backup").password) = env(BITBUCKET_PASS)' settings.yml

exec dotnet ScmBackup.dll