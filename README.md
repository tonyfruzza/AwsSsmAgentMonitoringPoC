## SSM Agent Monitor
Triggers a CloudWatch Alarm when an EC2 instance is not registered as a monitored SSM instance, but should be based on the matching configurable tags.

### Configuration
1. Set `alarm_sns_arn` within conifg-common.yml for where the alarm should be directed.
2. Set the target tags in env_vars-common.yml the tag key must be prefixed by `tag_` while the value can be a single string or a list of comma delimited strings.

### Management
This serverless framework is designed to be launched by runway. Create a module directory with a .sls folder extension, add the module to your runway.yml list. The example configuration files use -common.yml extensions, if you'd rather launch in a different environment you'll need to change those to match your desired environment name.


### Deployment
AWS infrastructure managed by [Serverles Framework](https://github.com/serverless/serverless) follow the install guidelines for your OS and AWS CLI. This example comes with a autoscaling group which launches an instance to be monitored. There are parameter values that must be configured to launch this within your VPC within `deploy.sh`. Configure your AWS credentials and then execute the provided `./deploy.sh` after performing the Configuration step to set your SNS topic.
