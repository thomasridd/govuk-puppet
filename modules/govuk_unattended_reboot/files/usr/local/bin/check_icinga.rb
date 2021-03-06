#!/usr/bin/env ruby

require 'json'
require 'net/http'
require 'time'
require 'uri'

class IcingaError < RuntimeError
end

module CheckIcinga
  REBOOT_REQUIRED_SERVICE_DESCRIPTION = "At least 1 machine requires reboots due to apt updates"

  def self.request(url)
    uri = URI.parse(url)

    http = Net::HTTP.new(uri.host, uri.port)

    if uri.scheme == "https"
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end

    req = Net::HTTP::Get.new(uri.request_uri)
    if ENV['BASIC_AUTH_USERNAME'] and ENV['BASIC_AUTH_PASSWORD']
      req.basic_auth ENV['BASIC_AUTH_USERNAME'], ENV['BASIC_AUTH_PASSWORD']
    end

    response = http.start { |http| http.request(req) }

    if response.code != "200"
      raise IcingaError, "Error: Non-200 HTTP response received. Got: " + response.code
    end

    return response.body
  end

  def self.parse_for_alerts!(body)
    icinga_status = JSON.parse(body)

    host_issues = icinga_status["status"]["host_status"].select do |status|
      ['DOWN', 'UNREACHABLE', 'PENDING'].include? status["status"]
    end

    service_issues = icinga_status["status"]["service_status"].select do |status|
      ['WARNING', 'CRITICAL'].include?(status["status"]) &&
        status["service_description"] != REBOOT_REQUIRED_SERVICE_DESCRIPTION
    end

    if host_issues.any?
      raise IcingaError, sprintf("Error: %d host alerts found.", host_issues.length)
    elsif service_issues.any?
      service_issues.each do |issue|
        STDERR.puts("service_issue: #{issue['host_name']} #{issue['service_description']}")
      end
      raise IcingaError, sprintf("Error: %d service alerts found.", service_issues.length)
    end
  end

  def self.run(url)
    begin
      body = self.request(url)
      self.parse_for_alerts!(body)
    rescue JSON::ParserError => e
      # Only output 72 characters to stop the JSON ParserError from
      # printing the entire malformed document.
      puts e.to_s[0,72]
      exit 2
    rescue IcingaError => e
      puts e
      exit 1
    end
  end
end

if __FILE__ == $0
  CheckIcinga.run(ARGV[0])
end
