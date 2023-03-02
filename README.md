## HCP Vault demo with Lambda
#

1. Before you begin, run `make` to compile the go app and zip the necessary files to be used as lambda function.
2. Run `terraform init`
3. Run `terraform apply`
4. Test It!

PS: You can run the test using AWS Lambda's UI. Use the trigger below:

```json
{
    "sample_data": "trigger"
}
```