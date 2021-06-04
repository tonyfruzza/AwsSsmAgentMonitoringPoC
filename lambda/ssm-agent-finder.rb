require 'csv'
require 'aws-sdk-ssm'
require 'aws-sdk-ec2'

def lambda_handler(event:, context:)
  ssm = Aws::SSM::Client.new(region: ENV['AWS_REGION'])
  ec2 = Aws::EC2::Client.new(region: ENV['AWS_REGION'])
  next_token = nil
  connected_instances = []
  api_instances = []

  # Get list of instances that are checking into SSM
  loop do
    dii = ssm.describe_instance_information({next_token: next_token}).to_h
    connected_instances += dii[:instance_information_list].select{|i| i[:ping_status] == 'Online'}.map{|i| i[:instance_id]}
    break unless next_token = dii[:next_token]
    next_token = dii[:next_token]
  end

  # Get list of tags to monitor
  filters = [{name: 'instance-state-name', values: ['running']}] + ENV.select{|key| /^tag/ =~ key}.map{|k, v| {name: "tag:#{k.split('_').drop(1).join('_')}", values: CSV.parse(v).first.map{|v| v.strip}}}

  # Get list of all API servers
  next_token = nil
  loop do
    di = ec2.describe_instances(
      {
        filters: filters,
        next_token: next_token
      }
    ).to_h

    api_instances += di[:reservations].map{|i| i[:instances].map{|n| n[:instance_id]}}.flatten
    break unless next_token = di[:next_token]
    next_token = di[:next_token]
  end

  # Are there any of the servers missing from this list?
  not_registered = api_instances - connected_instances
  unless not_registered.empty?
    raise JSON.pretty_generate(not_registered)
    return { statusCode: 500, body: api_instances }
  end
  { statusCode: 200, body: api_instances }
end
