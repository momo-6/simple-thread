require 'date'

# Holds the data assiciated with a project, and the logic for figuring out what type of day 
# any given day is in relation to this project
# also defines the three key types for calculating reimbursements.
class Project

  attr_reader :name, :start_date, :end_date, :city_cost_type

  CITY_COST_TYPE = {
    low: 0,
    high: 1,
  }

  # Day type is needed for the algorithm that computes the final reimbursement cost
  # We dont just have travel and full days, we have days that are just before or after a travel day that impact how 
  # travel days on other projects will be reimbursed.  Also there are days that are totally outside the project window.
  # So a day_type summarizes a given days relationship to this project.
  DAY_TYPE = {
    travel: 0,        # a day of travel only, no work
    full: 1,          # a full work day
    before_travel: 2, # exactly one day before a travel day for this project
    after_travel: 3,  # exactly one day after a travel day for this project
    outside: 4,       # a day well outside the date range for this project ( more than one day before start or after end )
  }

  # This type represents what cost impact a given day has.
  DAY_COST_TYPE = {
    none: 0,
    travel: 1,
    full: 2,
  }

  def initialize(fields_map)
    @name           = fields_map[:name]
    @city_cost_type = fields_map[:city_cost_type]
    # for simplicity assume the date is in MM/dd/YYYY format
    @start_date     = DateTime.strptime( fields_map[:start_date], "%m/%d/%Y")
    @end_date       = DateTime.strptime( fields_map[:end_date], "%m/%d/%Y")    
  end

  # given a date, what relationship does that date have to this project.
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