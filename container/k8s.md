# kubernetes

## basics

### create a cluster

### deploy an app

### explore your app

### expose your app publicly

#### Step 2: Using labels

The Deployment created automatically a label for our Pod. With `describe deployment` command you can see the name of the label:

```
kubectl describe deployment
```

Let’s use this label to query our list of Pods. We’ll use the `kubectl get pods` command with -l as a parameter, followed by the label values:

```
kubectl get pods -l run=kubernetes-bootcamp
```

You can do the same to list the existing services:

```
kubectl get services -l run=kubernetes-bootcamp
```

Get the name of the Pod and store it in the POD_NAME environment variable:

```
export POD_NAME=$(kubectl get pods -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}') echo Name of the Pod: $POD_NAME
```

To apply a new label we use the label command followed by the object type, object name and the new label:

```
kubectl label pod $POD_NAME app=v1
```

This will apply a new label to our Pod (we pinned the application version to the Pod), and we can check it with the describe pod command:

```
kubectl describe pods $POD_NAME
```

We see here that the label is attached now to our Pod. And we can query now the list of pods using the new label:

```
kubectl get pods -l app=v1
```

And we see the Pod.

#### Step 3 Deleting a service

To delete Services you can use the `delete service` command. Labels can be used also here:

```
kubectl delete service -l run=kubernetes-bootcamp
```

Confirm that the service is gone:

```
kubectl get services
```

This confirms that our Service was removed. To confirm that route is not exposed anymore you can `curl` the previously exposed IP and port:

```
curl $(minikube ip):$NODE_PORT
```

This proves that the app is not reachable anymore from outside of the cluster. You can confirm that the app is still running with a curl inside the pod:

```
kubectl exec -ti $POD_NAME curl localhost:8080
```

We see here that the application is up. This is because the Deployment is managing the application. To shut down the application, you would need to delete the Deployment as well.

## scale your app

### Running Multiple Instances of Your App

## kubectl Cheat Sheet

### Kubectl autocomplete

bash

```
source <(kubectl completion bash) # setup autocomplete in bash into the current shell, bash-completion package should be installed first.
echo "source <(kubectl completion bash)" >> ~/.bashrc # add autocomplete permanently to your bash shell.
```

You can also use a shorthand alias for `kubectl` that also works with completion:

```
alias k=kubectl
complete -F __start_kubectl k
```

zsh

```
source <(kubectl completion zsh)  # setup autocomplete in zsh into the current shell
echo "[[ $commands[kubectl] ]] && source <(kubectl completion zsh)" >> ~/.zshrc # add autocomplete permanently to your zsh shell
```

