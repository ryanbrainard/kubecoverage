# Build special test binary, package as an image, and push to registry
docker build -t ryanbrainard/go-test-coverage-demo-test-exec .
docker push ryanbrainard/go-test-coverage-demo-test-exec

# Deploy to test binary and coverage inspector to cluster
kubectl delete namespace go-test-coverage-demo
kubectl apply -f demo.yaml

# Run the test
kubectl -n go-test-coverage-demo port-forward --pod-running-timeout=10s service/test-exec 30001:http &
sleep 10
curl 'http://localhost:30001/?size=1'
curl 'http://localhost:30001/?size=100'

# Exit out of the test binary to generate test coverage file
kubectl -n go-test-coverage-demo delete pod -l app=test-exec

# Download output
kubectl -n go-test-coverage-demo port-forward --pod-running-timeout=10s service/coverage-viewer 30002:http &
sleep 10
curl -O 'http://localhost:30002/tmp/coverage/demo.cov'
go tool cover -html demo.cov
