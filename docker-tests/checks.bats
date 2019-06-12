#! /usr/bin/env bats

# Variable SUT_IP should be set outside this script and should contain the IP
# address of the System Under Test.

# Tests

@test 'Netdata listens 19999' {
  run bash -c "curl http://${SUT_IP}:19999"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
}

@test 'Netdata conf file exists and plugins are enabled' {
  run bash -c "docker exec -ti ${SUT_ID} cat /etc/netdata/netdata.conf"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ 'openio = yes' ]]
  [[ "${output}" =~ 'command = yes' ]]
}
