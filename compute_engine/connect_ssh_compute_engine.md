1 - Install GCP CLI

2 - Generate SSH keys - to do this use ``` gcloud compute ssh --project=PROJECT_ID --zone=ZONE VM_NAME ``` 

   By default, gcloud expects keys to be located at the following paths:
   
   * $HOME/.ssh/google_compute_engine – private key
   * $HOME/.ssh/google_compute_engine.pub – public key

3 - Create config file

4 - Install Remote SSH extension and Add new SSH host

5 - Connect
