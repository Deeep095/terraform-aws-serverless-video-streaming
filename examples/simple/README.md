# Simpler Example for the module 
Simpler demonstration of the basic usage of the serverless video streaming module.

# Usage

```bash
terraform init
terraform apply
```

# Upload a Video

```bash
aws s3 cp your-video.mp4 s3://$(terraform output -raw input_bucket)/uploads/your-video.mp4
```
