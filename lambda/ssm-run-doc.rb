require 'aws-sdk-ssm'

def lambda_handler(event:, context:)
  ssm = Aws::SSM::Client.new(region: ENV['AWS_REGION'])

  # Get list of instances that are checking into SSM
  managed_instances = []
  next_token = nil
  loop do
    dii = ssm.describe_instance_information({next_token: next_token}).to_h
    managed_instances += dii[:instance_information_list].map{|i| i[:instance_id]}
    break unless next_token = dii[:next_token]
    next_token = dii[:next_token]
  end

  puts "Targeting #{managed_instances}"
  managed_instances.each do |mi|
    ssm.send_command({
      targets: [{key: 'InstanceIds', values: managed_instances}],
      document_name: 'AWS-RunPowerShellScript',
      parameters: {
        commands: ["aws --region #{ENV['AWS_REGION']} cloudwatch put-metric-data --metric-name heart-beat --namespace mi-health --value 1 --dimensions InstanceID=#{mi}"]
      },
      timeout_seconds: 300
    })
  end
end
