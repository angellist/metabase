require 'buildkite_utils'

NAME = :metabase
STEPS = []

["amd64", "arm64"].each do |arch|
  STEPS << BuildkiteUtils.build_step(name: NAME, target: :runner, arch: arch)
end

STEPS << BuildkiteUtils.deploy_manifest_step(name: NAME, target: :runner)

puts BuildkiteUtils.dump!(steps: STEPS)
