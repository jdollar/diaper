module DiaperPartnerClient
  def self.post(attributes)
    return if Rails.env != "production"

    partner = { partner:
      { diaper_bank_id: attributes["organization_id"],
        diaper_partner_id: attributes["id"],
        email: attributes["email"] } }

    uri = URI(ENV["PARTNER_REGISTER_URL"])
    req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
    req.body = partner.to_json
    req["Content-Type"] = "application/json"
    req["X-Api-Key"] = ENV["PARTNER_KEY"]

    response = https(uri).request(req)

    response.body
  end

  def self.approve(attributes)
    return if Rails.env != "production"

    partner = { partner:
                    { diaper_bank_id: attributes["organization_id"],
                      diaper_partner_id: attributes["id"],
                      approved: "true" } }

    uri = URI(ENV["PARTNER_APPROVAL_URL"])
    req = Net::HTTP::Post.new(uri, "Content-Type" => "application/json")
    req.body = partner.to_json
    req["Content-Type"] = "application/json"
    req["X-Api-Key"] = ENV["PARTNER_KEY"]

    response = https(uri).request(req)

    response.body
  end

  def self.https(uri)
    Net::HTTP.new(uri.host, uri.port).tap do |http|
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    end
  end
end
