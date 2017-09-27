
class TriggerTracker < Array
  def trigger?()
    return false if self.empty?
    self.any?{ |r| r.updated_by_last_action? }
  end
end