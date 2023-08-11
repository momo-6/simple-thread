require 'date'


class Project

  attr_reader :start_date, :end_date

  # we may want to persist this in a DB, so separate it from price so we can 
  #  1. change the prices dynamically in the future, and
  #  2. have the DB table save the cost type, but save the actual prices in a different table.
  CITY_COST_TYPE = {
    low: 0,
    high: 1,
  }

  DAY_TYPE = {
    travel: 0,        # a day of travel only, no work
    full: 1,          # a full work day
    before_travel: 2, # exactly one day before a travel day for this project
    after_travel: 3,  # exactly one day after a travel day for this project
    outside: 4,       # a day well outside the date range for this project ( more than one day before start or after end )
  }

  def initialize(fields_map)
    @name           = fields_map[:name]
    @city_cost_type = fields_map[:city_cost_type]
    # for simplicity assume the date is in MM/dd/YYYY format
    @start_date     = DateTime.strptime( fields_map[:start_date], "%m/%d/%Y")
    @end_date       = DateTime.strptime( fields_map[:end_date], "%m/%d/%Y")


    @day_cost_map ={
      DAY_TYPE[:travel] => {CITY_COST_TYPE[:low] => 45.00, CITY_COST_TYPE[:high] => 55.00},
      DAY_TYPE[:full] => {CITY_COST_TYPE[:low] => 75.00, CITY_COST_TYPE[:high] => 85.00},
    }
    
  end

  def day_type(date)
    start_date_delta = (date - @start_date).to_i
    end_date_delta = (date - @end_date).to_i
    return DAY_TYPE[:before_travel] if start_date_delta == -1
    return DAY_TYPE[:travel] if start_date_delta == 0 || end_date_delta == 0
    return DAY_TYPE[:full] if start_date_delta > 0 && end_date_delta < 0
    return DAY_TYPE[:after_travel] if end_date_delta == 1

    # else the date is well outside the project date range
    DAY_TYPE[:outside]
  end
end