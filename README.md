## SSM Agent Monitor
Triggers a CloudWatch Alarm when a managed instance is not capable of receiving SSM commands and generating an CloudWatch Metric within the allotted threshold of time.

### Configuration
1. Set `alarm_sns_arn` within conifg-common.yml for where the alarm should be directed.
2. Duplicate the example CloudWatch alarm in the resources section to match your managed instances. One for each instance.

Your IAM role assigned to your managed instance should include at least these managed policies:
* AmazonSSMManagedInstanceCore
* CloudWatchAgentServerPolicy

### Management
This serverless framework is designed to be launched by runway. Create a module directory with a .sls folder extension, add the module to your runway.yml list. The example configuration files use -common.yml extensions, if you'd rather launch in a different environment you'll need to change those to match your desired environment name.


### Deployment
AWS infrastructure managed by [Serverles Framework](https://github.com/serverless/serverless) follow the install guidelines for your OS and AWS CLI. This example comes with a autoscaling group which launches an instance to be monitored. There are parameter values that must be configured to launch this within your VPC within `deploy.sh`. Configure your AWS credentials and then execute the provided `./deploy.sh` after performing the Configuration step to set your SNS topic.
