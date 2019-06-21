#!/usr/bin/env bash

set -e

on_exit() {
  exitcode=$?
  if [ $exitcode != 0 ] ; then
    echo -e '\e[41;33;1m'"Failure encountered!"'\e[0m'
  fi
}

trap on_exit EXIT

test() {
  set -e
  base_dir="$(cd "$(dirname $0)" ; pwd )"
  if [ -f "${base_dir}/../out" ] ; then
    cmd="../out"
  elif [ -f /opt/resource/out ] ; then
    cmd="/opt/resource/out"
  fi

  cat <<EOM >&2
------------------------------------------------------------------------------
TESTING: $1

Input:
$(cat ${base_dir}/${1}.out)

Output:
EOM

  result="$(cd $base_dir && cat ${1}.out | $cmd . 2>&1 | tee /dev/stderr)"
  echo >&2 ""
  echo >&2 "Result:"
  echo "$result" # to be passed into jq -e
}

# simulate environment as in executing the resource in Concourse
export BUILD_PIPELINE_NAME='my-pipeline'
export BUILD_JOB_NAME='my-job'
export BUILD_NAME='my-build'
export BUILD_TEAM_NAME='main'
export ATC_EXTERNAL_URL='http://concourse.local'

url='http://rocketchat:3000'
user='admin'
password='password'
debug='1'
channel='general'
message='test message'

test 'default_source_and_params' | jq -e "
    .url == $(echo $url | jq -R .) and
    .body.channel == $(echo $channel | jq -R .) and
    .body.text == $(echo $message | jq -R .) and
    .body.alias == $(echo 'Concourse' | jq -R .) and
    .body.attachments[0].title == $(echo ${BUILD_TEAM_NAME}/pipelines/${BUILD_PIPELINE_NAME}/jobs/${BUILD_JOB_NAME} | jq -R .) and
    .body.attachments[0].title_link == $(echo ${ATC_EXTERNAL_URL}/teams/${BUILD_TEAM_NAME}/pipelines/${BUILD_PIPELINE_NAME}/jobs/${BUILD_JOB_NAME}/builds/${BUILD_NAME} | jq -R .) and
    .body.avatar == $(echo 'https://concourse-ci.org/images/trademarks/concourse-black.png' | jq -R .)"

# TODO add another test, that leaves all the "default" values empty and check, whether they are set as expected