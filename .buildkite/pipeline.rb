require 'json'

STEPS = []

["amd64", "arm64"].each do |arch|
  STEPS << {
    label: "Build: #{arch}",
    key: "build:#{arch}",
    timeout_in_minutes: 40,
    retry: { automatic: [{ exit_status: '*', limit: 1 }] },
    env: {
      BUILDKIT_HOST: "tcp://buildkitd-#{arch}:1234",
    },
    plugins: [{
      "venturehacks/buildkit#master": {
        context: 'bin/docker',
        output: [{ type: :image, push: true, name: "angellistventure/metabase:#{ENV['BUILDKITE_COMMIT']}-#{arch}" }]
      },
    }],
  }
end

STEPS << {
  label: 'Push Manifest',
  key: :push,
  depends_on: ['build:arm64', 'build:amd64'],
  timeout_in_minutes: 15,
  command: <<-EOF
    export DOCKER_CLI_EXPERIMENTAL=enabled
    docker manifest create -a angellistventure/metabase:latest #{["arm64", "amd64"].map {|arch| "angellistventure/metabase:#{ENV['BUILDKITE_COMMIT']}-#{arch}"}.join(" ")}
    docker manifest push -p angellistventure/metabase:latest
EOF
}

puts JSON.dump(steps: STEPS)
