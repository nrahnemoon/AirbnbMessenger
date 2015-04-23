class Ip < ActiveRecord::Base


	AWS_REGIONS = [ "ap-northeast-1", "ap-southeast-1", "ap-southeast-2", "eu-central-1", "eu-west-1", "sa-east-1", "us-east-1", "us-west-1", "us-west-2" ]

	def self.set_new_ip(region)
		ec2 = AWS::EC2.new(:region => region)
		
		# There has to be a pre-existing intance
		if ec2.instances.first == nil
			return false
		end

		# Delete existing elastic ips
		while ec2.elastic_ips.first != nil
			ec2.elastic_ips.first.release
		end

		while true
			ip = ec2.elastic_ips.allocate
			if !Ip.exists?(:address => ip.public_ip)
				new_ip = Ip.create(:address => ip.public_ip, :region => region)
				ip.associate(:instance => ec2.instances.first.id)
				return new_ip
			end
			ip.release
		end
	end

	def self.allocate_ips
		AWS_REGIONS.each { |region|
			ec2 = AWS::EC2.new(:region => region)
			puts "CHECKING IPS IN REGION #{region}"
			numSkipped = 0
			while numSkipped < 50
				puts "REQUESTING IP IN REGION #{region}"
				ip = ec2.elastic_ips.allocate
				if !Ip.exists?(:address => ip.public_ip)
					puts "NEW IP #{ip.public_ip} FOUND IN REGION #{region}!"
					Ip.create(:address => ip.public_ip, :region => region)
					numSkipped = 0
				end
				numSkipped += 1
				puts "RELEASING IP #{ip.public_ip}"
				ip.release
			end
		}
	end

	def self.release_ips
		AWS_REGIONS.each { |region|
			puts "DELETING IPS ON REGION #{region}"
			ec2 = AWS::EC2.new(:region => region)
			ip = ec2.elastic_ips.first
			while ip != nil
				puts "DELETING IP #{ip.public_ip} ON REGION #{region}"
				ip.release
				ip = ec2.elastic_ips.first
			end
		}
	end
end
