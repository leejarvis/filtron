module Filtron
  VERSION = "0.0.1"

  def filtron_filters
    @filtron_filters ||= {}
  end

  def filtron_query_predicate
    @filtron_query_predicate
  end

  def filtron_query_param
    @filtron_query_param ||= :q
  end

  def filter_with(param, predicate, options = {}, &block)
    filtron_filters[param] = [predicate, options, block]
  end

  def queries(*columns)
    options = columns[-1].is_a?(Hash) ? columns.pop : {}
    suffix  = options.fetch(:suffix, "_cont")
    suffix  = "_#{suffix}" unless suffix.start_with?("_")

    @filtron_query_param     = options.fetch(:with, @filtron_query_param)
    @filtron_query_predicate = columns.join("_or_") + suffix
  end

  def filter(filters)
    conditions = filters_to_conditions(filters)

    if filters[:ransack_options]
      search(conditions).result(filters[:ransack_options])
    else
      search(conditions)
    end
  end

  protected

  def filters_to_conditions(params)
    predicates = filtron_filters
    filters    = filters_from_predicates(params, predicates)
    add_query_predicate(filters, params)
    Hash[filters]
  end

  def filters_from_predicates(params, predicates)
    slice(params, *predicates.keys).map do |key, value|
      filter = predicates[key]
      value  = filter[-1].call(value) if filter[-1].respond_to?(:call)
      [filter[0], value]
    end
  end

  def slice(hash, *keys)
    keys.each_with_object({}) { |k, h| h[k] = hash[k] if hash.key?(k) }
  end

  def add_query_predicate(filters, params)
    key = filtron_query_param
    if key && params[key]
      filters << [filtron_query_predicate, params[key]]
    end
  end
end

if defined? ActiveRecord::Base
  ActiveRecord::Base.extend Filtron
end
