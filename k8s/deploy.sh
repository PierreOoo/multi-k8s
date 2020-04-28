set -x
echo "SHA=$SHA"
docker build -t pmigalski/multi-client:latest -t pmigalski/multi-client:$SHA -f ./client/Dockerfile ./client
docker build -t pmigalski/multi-server:latest -t pmigalski/multi-server:$SHA -f ./server/Dockerfile ./server
docker build -t pmigalski/multi-worker:latest -t pmigalski/multi-worker:$SHA -f ./worker/Dockerfile ./worker
docker push pmigalski/multi-client:latest
docker push pmigalski/multi-server:latest
docker push pmigalski/multi-worker:latest
docker push pmigalski/multi-client:$SHA
docker push pmigalski/multi-server:$SHA
docker push pmigalski/multi-worker:$SHA
kubectl apply -f k8s
kubectl set image deployments/server-deployment server=pmigalski/multi-server:$SHA
kubectl set image deployments/client-deployment client=pmigalski/multi-client:$SHA
kubectl set image deployments/worker-deployment worker=pmigalski/multi-worker:$SHA
