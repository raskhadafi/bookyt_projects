ENV["RAILS_ENV"] ||= 'test'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require "bundler/setup"
require "rails"
require 'action_view/railtie'
Bundler.require(:default)
require 'action_controller/railtie'
require 'active_record'
require 'inherited_resources'
require 'devise'
require 'cancan'
require 'validates_timeliness'
require 'factory_girl_rails'

ActiveRecord::Base.establish_connection(:adapter => 'sqlite3', :database => ':memory:')
ActiveRecord::Migration.verbose = false

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.dirname(__FILE__), "support/**/*.rb")].each {|f| require f}

require 'rspec/rails'
RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true
  
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
end

ActiveRecord::Schema.define do
  create_table :people, :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.date     "date_of_birth"
    t.date     "date_of_death"
    t.integer  "sex"
    t.string   "code"
    t.string   "social_security_nr"
    t.string   "social_security_nr_12"
    t.integer  "civil_status_id"
    t.integer  "religion_id"
  end
end
class Person < ActiveRecord::Base
  # Validations
  validates_date :date_of_birth, :date_of_death, :allow_nil => true, :allow_blank => true
  validates_presence_of :vcard

  # sex enumeration
  MALE   = 1
  FEMALE = 2

  # String
  def to_s(format = :default)
    return unless vcard

    s = vcard.full_name

    case format
      when :long
        s += " (#{vcard.locality})" if vcard.locality
    end

    return s
  end

  # VCards
  # ======
  has_many :vcards, :as => :object
  has_one :vcard, :as => :object
  accepts_nested_attributes_for :vcard

  # Search
  default_scope includes(:vcard).order('IFNULL(vcards.full_name, vcards.family_name + ' ' + vcards.given_name)')

  scope :by_name, lambda {|value|
    includes(:vcard).where("(vcards.given_name LIKE :query) OR (vcards.family_name LIKE :query) OR (vcards.full_name LIKE :query)", :query => "%#{value}%")
  }

  # Constructor
  def initialize(attributes = nil, options = {})
    super

    build_vcard unless vcard
    vcard.build_address unless vcard.address
  end

  # Invoices
  # ========
  has_many :credit_invoices, :class_name => 'Invoice', :foreign_key => :customer_id, :order => 'value_date DESC'
  has_many :debit_invoices, :class_name => 'Invoice', :foreign_key => :company_id, :order => 'value_date DESC'

  # Charge Rates
  # ============
  has_many :charge_rates

  # Attachments
  # ===========
  has_many :attachments, :as => :object
  accepts_nested_attributes_for :attachments, :reject_if => proc { |attributes| attributes['file'].blank? }

  # Others
  # ===========
  belongs_to :civil_status
  belongs_to :religion
  has_many :notes, :as => :note_of_sth

end

ActiveRecord::Schema.define do
  create_table "roles", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
end
class Role < ActiveRecord::Base
  # Associations
  has_and_belongs_to_many :users

  # Helpers
  def to_s
    I18n.translate(name, :scope => 'cancan.roles')
  end
end

ActiveRecord::Schema.define do
  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "person_id"
    t.integer  "tenant_id"
    t.string   "locale"
  end
end
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  # Tenancy
  belongs_to :tenant

  # Authorization roles
  has_and_belongs_to_many :roles, :autosave => true
  scope :by_role, lambda{|role| include(:roles).where(:name => role)}
  attr_accessible :role_texts

  def role?(role)
    !!self.roles.find_by_name(role.to_s)
  end

  def role_texts
    roles.map{|role| role.name}
  end

  def role_texts=(role_names)
    self.roles = Role.where(:name => role_names)
  end

  # Associations
  belongs_to :person
  validates_presence_of :person
  accepts_nested_attributes_for :person
  attr_accessible :person, :person_attributes

  # Shortcuts
  def current_company
    person.try(:employers).try(:first)
  end

  # Helpers
  def to_s
    person.try(:to_s) || ""
  end
end


class ApplicationController < ActionController::Base
  # Aspects
  protect_from_forgery

  # Authentication
  before_filter :authenticate_user!

  # Tenancy
  def current_tenant
    current_user.tenant
  end
end

class AuthorizedController < InheritedResources::Base
  # Authorization
  # authorize_resource

  rescue_from CanCan::AccessDenied do |exception|
    flash[:alert] = t('cancan.access_denied')
    redirect_to :back
  end

  # Responders
  respond_to :html, :js

  # Set the user locale
  before_filter :set_locale
  def set_locale
    I18n.locale = current_user.locale if current_user
  end

  # Resource setup
  protected
    def collection
      instance_eval("@#{controller_name.pluralize} ||= end_of_association_chain.accessible_by(current_ability, :list).paginate(:page => params[:page], :per_page => params[:per_page])")
    end
end

# a fake app for initializing the railtie
app = Class.new(Rails::Application)
app.config.secret_token = "token"
app.config.session_store :cookie_store, :key => "_myapp_session"
app.config.active_support.deprecation = :log
app.config.action_controller.perform_caching = false
app.initialize!

