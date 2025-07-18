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

    def all_tokens
      [new]
    end

    def active_tokens
      [new]
    end

    def active_non_trial_tokens
      [new]
    end

    def active_trial_token
      nil
    end

    def table_exists?
      true
    end

    def trial_only?
      false
    end

    def available_features
      []
    end

    def non_trialling_features
      []
    end

    def trialling_features
      []
    end

    def trialling?(feature)
      false
    end

    def user_limit
      nil
    end

    def set_active_tokens
      [new]
    end

    def clear_current_tokens_cache
      true
    end
  end

  delegate :will_expire?,
           :subscriber,
           :mail,
           :company,
           :domain,
           :issued_at,
           :starts_at,
           :expires_at,
           :reprieve_days,
           :reprieve_days_left,
           :restrictions,
           :available_features,
           :plan,
           :features,
           :version,
           :started?,
           :trial?,
           :active?,
           to: :token_object

  def token_object
    @token_object ||= Class.new do
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
        70
      end

      def started?
        true
      end

      def trial?
        false
      end

      def active?(reprieve: true)
        true
      end

      def expired?(reprieve: true)
        false
      end

      def validate_domain?
        false
      end

      def valid_domain?(hostname)
        true
      end
    end.new
  end


  def id
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

  def expiring_soon?
    false
  end

  def in_grace_period?
    false
  end

  def statuses
      statuses = []
      if trial?
        statuses << :trial
      end
      if invalid_domain?
        statuses << :invalid_domain
      end
      if !started?
        statuses << :not_active
      elsif expiring_soon?
        statuses << :expiring_soon
      elsif in_grace_period?
        statuses << :in_grace_period
      elsif expired?
        statuses << :expired
      end
      statuses
    end

  def unlimited_users?
    true
  end

  def max_active_users
    nil
  end

  def sort_key
    [Time.zone.today + 1000.years, Time.zone.today - 1]
  end

  def days_left
    365000 # A very large number
  end

  def clear_current_tokens_cache
    true
  end
end