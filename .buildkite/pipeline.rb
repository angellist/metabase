require 'buildkite_utils'

NAME = :metabase
STEPS = []

["amd64", "arm64"].each do |arch|
  STEPS << BuildkiteUtils.build_step(name: NAME, target: nil, context: 'bin/docker', arch: arch)
end

# STEPS << BuildkiteUtils.deploy_manifest_step(name: NAME, target: :test)

puts JSON.dump(steps: STEPS)
