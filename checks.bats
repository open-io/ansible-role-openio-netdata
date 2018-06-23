#! /usr/bin/env bats

# Variable SUT_IP should be set outside this script and should contain the IP
# address of the System Under Test.

# Tests

@test 'NAME - test1' {
  run bash -c "docker exec -ti ${SUT_ID} cat /etc/foo"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" ]]
  [[ "${output}" =~ 'String in the output1' ]]
  [[ "${output}" =~ 'String in the output2' ]]
}
