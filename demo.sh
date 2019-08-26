function kill_port_forward() {
  pkill kubectl -n go-test-coverage-demo port-forward
}

function await_port_forward() {
  kill_port_forward
  out=/tmp/port-fwd-out
  rm $out
  touch $out
  kubectl port-forward -n go-test-coverage-demo --pod-running-timeout=1m0s "$@" > $out &
  tail -f $out | grep -m 1 'Forwarding from'
}

trap kill_port_forward EXIT

# Build special test binary, package as an image, and push to registry
docker build -t ryanbrainard/go-test-coverage-demo-test-exec .
docker push ryanbrainard/go-test-coverage-demo-test-exec

# Deploy to test binary and coverage inspector to cluster
kubectl delete namespace go-test-coverage-demo
kubectl apply -f demo.yaml
sleep 10 # avoid port fwd race

# Run the test
await_port_forward service/test-exec 30001:http
curl 'http://localhost:30001/?size=1'
curl 'http://localhost:30001/?size=100'

# Exit out of the test binary to generate test coverage file
kubectl -n go-test-coverage-demo delete pod -l app=test-exec

# Download output
await_port_forward service/coverage-viewer 30002:http
rm /tmp/coverage/demo.cov
curl -s -O 'http://localhost:30002/tmp/coverage/demo.cov'

# View coverage report
go tool cover -html demo.cov
