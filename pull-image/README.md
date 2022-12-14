### k8s conformance in air-gap env

***
+ check conformance in k8s https://github.com/cncf/k8s-conformance/blob/master/instructions.md
+ use sonobuoy https://github.com/vmware-tanzu/sonobuoy/issues/1223

***

- check your private registry ip in `check_status.sh` and private registry password in `auto_push.sh`
1. edit sonobuoy config 
```
sonobuoy gen default-image-config > custom-repo-config.yaml
```
- and edit it referring to your private regristry
- that means, config cri(docker/containerd) registry dependency on all your cluster node
2. start up sonobuoy
```sh
sonobuoy run  --mode=certified-conformance  \
    --plugin e2e \
    --e2e-repo-config ./custom-repo-config.yaml \
    --kube-conformance-image docker.io/ycsit/conformance:v1.24.0 \
    --sonobuoy-image docker.io/sonobuoy/sonobuoy:v0.56.10 
```
- confornamce version follows k8s version
3. set up check-script
- remember to give authority first 
- just run on master node
```sh
chmod +x check_status.sh && chmod +x auto_pull.sh
```
```sh
nohup ./check_status.sh > mycheckimg.log 2>&1 &
```
- then you can get pid [CHECK_PID]
4. check sonobuoy and wait for success
```sh
sonobuoy status
```
```sh
sonobuoy logs
```
5. get the result
```sh
outfile=$(sonobuoy retrieve)
```
```sh
mkdir ./results; tar xzf $outfile -C ./results
```
6. clean up 
```sh
sonobuoy delete
```
```sh
kill [CHECK_PID]
```
- or you can search pid first
```sh
ps -aux | grep "check"
```
