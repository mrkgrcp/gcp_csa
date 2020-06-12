# Cloud Security Assessment Tool

## Usage (TODO)
### Building the dockerfile
```
sudo docker build --no-cache -t gcp_scout .
```
### Running the container
```
sudo docker run -dt -v "$PWD/ansible/playbooks":/opt/playbooks --name gcp_scout --hostname gcp_scout gcp_scout 
```
### Access the container
```
sudo docker exec -it gcp_scout /bin/bash
```

## Useful commands (TODO)
Once inside the container a simple test run can be executed:
```
ansible-playbook ./playbooks/gcp_scout_assessment.yml
```

## About the Service Account
The service account created must be present in the projects to assess
The service account must be authoprized inside the instance or container (already handled by the playbook so far)
Example:
```
gcloud auth activate-service-account --key-file=$WORKDIR/ansible/roles/gcp_scout/files/gcp-csa.secret.json
```
It is not necessary to invoke gcloud init since we want all the projects available

TODO The following capabilities and APIs must be enabled in the projects (TODO testing organization-wide capabilities)
_Cloud Resource Manager API

The following roles must be assigned in the project to the service account
_Browser
_Viewer
