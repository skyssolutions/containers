class EnterpriseToken < ApplicationRecord
  FAR_FUTURE_DATE = Date.new(9999, 1, 1)
  private_constant :FAR_FUTURE_DATE

  validates :encoded_token, presence: true, uniqueness: true
  validate :valid_token_object
  validate :valid_domain
  validate :one_trial_token

  before_validation :strip_encoded_token
  before_save :extract_validity_from_token
  before_save :clear_current_tokens_cache
  before_destroy :clear_current_tokens_cache

  scope :active, ->(date = Date.current) {
    where("valid_from IS NULL OR valid_from <= :date", date: date)
      .where("valid_until IS NULL OR valid_until >= :date", date: date)
  }

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
           to: :mock_token_object

  def mock_token_object
    @mock_token_object ||= MockToken.new(encoded_token)
  end

  def expiring_soon?
    mock_token_object.will_expire? && mock_token_object.active?(reprieve: false) &&
      mock_token_object.expires_at <= 365.days.from_now
  end

  def in_grace_period?
    mock_token_object.expired?(reprieve: false) && !mock_token_object.expired?(reprieve: true)
  end

  def expired?(reprieve: true)
    mock_token_object.expired?(reprieve:)
  end

  def statuses
    statuses = []
    statuses << :trial if trial?
    statuses << :invalid_domain if invalid_domain?
    statuses << :not_active unless started?
    statuses << :expiring_soon if expiring_soon?
    statuses << :in_grace_period if in_grace_period?
    statuses << :expired if expired?
    statuses
  end

  def invalid_domain?
    return false unless mock_token_object&.validate_domain?

    !mock_token_object.valid_domain?(Setting.host_name)
  end

  def unlimited_users?
    max_active_users.nil?
  end

  def max_active_users
    Hash(mock_token_object.restrictions)[:active_user_count]
  end

  def sort_key
    [expires_at || FAR_FUTURE_DATE, starts_at || FAR_FUTURE_DATE]
  end

  def days_left
    (expires_at.to_date - Time.zone.today).to_i
  end

  private

  def strip_encoded_token
    self.encoded_token = encoded_token.strip if encoded_token.present?
  end

  def load_token!
    # Mocked method, no actual token import
    @mock_token_object = MockToken.new(encoded_token)
  rescue => e
    Rails.logger.error "Failed to load token: #{e}"
    nil
  end

  def valid_token_object
    errors.add(:encoded_token, :unreadable) unless mock_token_object.valid?
  end

  def valid_domain
    errors.add :domain, :invalid if invalid_domain?
  end

  def one_trial_token
    if self.class.active_trial_token.present?
      errors.add :base, :only_one_trial
    end
  end

  def extract_validity_from_token
    return unless mock_token_object

    self.valid_from = mock_token_object.starts_at
    self.valid_until = if mock_token_object.will_expire?
                         mock_token_object.expires_at.next_day(mock_token_object.reprieve_days.to_i)
                       end
  end

  def clear_current_tokens_cache
    RequestStore.delete :current_ee_tokens
  end

  class MockToken
    attr_reader :encoded_token

    def initialize(encoded_token)
      @encoded_token = encoded_token
      @expires_at = 365.days.from_now
      @starts_at = Time.now
      @reprieve_days = 365
    end

    def will_expire?
      expires_at <= Time.now
    end

    def expired?(reprieve: true)
      expires_at < Time.now - reprieve_days.days
    end

    def active?(reprieve: true)
      !expired?(reprieve: reprieve)
    end

    def valid_domain?(domain)
      true
    end

    def validate_domain?
      true
    end

    def valid?
      true
    end

    def starts_at
      @starts_at
    end

    def expires_at
      @expires_at
    end

    def reprieve_days
      @reprieve_days
    end

    def restrictions
      { active_user_count: 1000 }
    end

    def available_features
      []
    end

    def plan
      "free_enterprise"
    end

    def version
      95
    end

    def trial?
      false
    end

    def subscriber
      "Jane Doe"
    end

    def mail
      "user@example.com"
    end

    def company
      "Example Corp"
    end
  end
end
