class Project

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
    before_travel: 2, # day is neither travel nor full, but is before a travel day for a given project
    after_travel: 3,  # day is neither travel nor full, but is after a travel day for a given project
    outside: 4,       # not a travel, work, or adjacent day; well outside the scheduled project days
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
end