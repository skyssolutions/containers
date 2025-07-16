class EnterpriseToken < ApplicationRecord
  class << self
    def current
      self.new
    end

    def allows_to?(feature)
      true
    end

    def active?
      true
    end

    def hide_banners?
      true
    end

    def show_banners?
      false
    end

    def banner_type_for(feature:)
      nil
    end
  end

  def token_object
    Class.new do
      def has_feature?(feature)
        true
      end

      def will_expire?
        false
      end

      def mail
        "admin@example.com"
      end

      def subscriber
        "markasoftware-free-enterprise-mode"
      end

      def company
        "markasoftware"
      end

      def domain
        "markasoftware.com"
      end

      def issued_at
        Time.zone.today - 1
      end

      def starts_at
        Time.zone.today - 1
      end

      def expires_at
        Time.zone.today + 1
      end

      def reprieve_days
        nil
      end

      def reprieve_days_left
        69
      end

      def restrictions
        nil
      end

      def available_features
        []
      end

      def plan
        "markasoftware_free_enterprise_mode"
      end

      def features
        []
      end
      
      def version
        69
      end
    end.new
  end

  def will_expire?
    false
  end

  def mail
    "admin@example.com"
  end

  def subscriber
    "markasoftware-free-enterprise-mode"
  end

  def company
    "markasoftware"
  end

  def domain
    "markasoftware.com"
  end

  def issued_at
    Time.zone.today - 1
  end

  def starts_at
    Time.zone.today - 1
  end

  def expires_at
    Time.zone.today + 1
  end

  def reprieve_days
    nil
  end

  def reprieve_days_left
    69
  end

  def restrictions
    nil
  end

  def available_features
    []
  end

  def plan
    "markasoftware_free_enterprise_mode"
  end

  def features
    []
  end
  
  def version
    69
  end

  def allows_to?(action)
    true
  end

  def expired?(reprieve: true)
    false
  end

  def invalid_domain?
    false
  end
end
