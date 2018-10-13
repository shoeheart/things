# frozen_string_literal: true

class Util::AuditTrail
  def self.to_hash(logidze_versions:)
    result = {
      fields: logidze_versions.map { |v|
        v.changes.keys.flatten
      }.flatten.uniq.reject { |f| f == "id" },
      versions: []
    }
    logidze_versions.each { |v|
      result[:versions] << {
        version: v.version,
        responsible_id: v.meta["responsible_id"],
        time: Time.at(v.time / 1000, v.time % 1000).to_s,
        changes: Hash[v.changes.map { |k, v|
          [
            k,
            [true, false].include?(v) ? v.to_s : v
          ]
        }]
      }
    }
    result
  end
end
