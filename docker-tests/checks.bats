#! /usr/bin/env bats

# Variable SUT_IP should be set outside this script and should contain the IP
# address of the System Under Test.

# Tests

@test 'Netdata is up and running on port 6921' {
  run bash -c "curl -qs http://${SUT_IP}:6921/api/v1/info"
  echo "output: "$output
  echo "status: "$status
  [[ "${status}" -eq "0" && "${output}" == *"\"version\""* ]]
}

@test 'Netdata returns valid cpu metrics' {
  run bash -c "curl -qs http://${SUT_IP}:6921/api/v1/allmetrics?format=prometheus_all_hosts"
  echo "output: "$output
  echo "status: "$status
  check="netdata_system_cpu_percentage_average\{chart=\"system.cpu\",family=\"cpu\",dimension=\"(steal|irq|soft_irq|user|system|nice|iowait|idle)\",instance=\"${SUT_ID}\"}"
  echo "check= $check"
  [[ "${status}" -eq "0" && "${output}" =~ $check ]]
}

@test 'Netdata returns valid memory metrics' {
  run bash -c "curl -qs http://${SUT_IP}:6921/api/v1/allmetrics?format=prometheus_all_hosts"
  echo "output: "$output
  echo "status: "$status
  check="netdata_system_ram_MiB_average\{chart=\"system.ram\",family=\"ram\",dimension=\"(free|used|cached|buffers)\",instance=\"${SUT_ID}\"}"
  [[ "${status}" -eq "0" && "${output}" =~ $check ]]
}

@test 'Netdata returns valid load metrics' {
  run bash -c "curl -qs http://${SUT_IP}:6921/api/v1/allmetrics?format=prometheus_all_hosts"
  echo "output: "$output
  echo "status: "$status
  check="netdata_system_load_load_average\{chart=\"system.load\",family=\"load\",dimension=\"(load1|load5|load15)\",instance=\"${SUT_ID}\"}"
  [[ "${status}" -eq "0" && "${output}" =~ $check ]]
}

@test 'Netdata returns valid apps.group metrics' {
  run bash -c "curl -qs http://${SUT_IP}:6921/api/v1/allmetrics?format=prometheus_all_hosts"
  echo "output: "$output
  echo "status: "$status
  check="netdata_apps_cpu_percentage_average\{chart=\"apps.cpu\",family=\"cpu\",dimension=\"other\",instance=\"${SUT_ID}\"}"
  echo "check= $check"
  [[ "${status}" -eq "0" && "${output}" =~ $check ]]
}
