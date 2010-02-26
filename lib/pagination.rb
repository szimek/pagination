require 'rubygems'
require 'bundler'
Bundler.setup

require 'sqlite3'
require 'active_record'
require 'action_view'

# Loads extensions to Ruby on Rails libraries needed to support pagination and lazy loading
require 'active_record/base_extensions'
require 'active_record/scope_extensions'

# Loads internal pagination classes
require 'pagination/collection'
require 'pagination/named_scope'
require 'pagination/enumerable'
require 'pagination/view_helpers'

# Loads the :paginate view helper
ActionView::Base.send :include, Pagination::ViewHelpers
