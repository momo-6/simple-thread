require './project'


# This classes role is to hold the list of projects, and any data associated with that list ( for now just name )
#  and to hold the strategy for calculating the total reimbursement, which can be swapped out in the future for another
#  way of calculating it.
class ProjectSet
  attr_reader :name, :first_start_date, :last_end_date, :project_list, :reimbursement_calculator

  def initialize(name, reimbursement_calculator, project_list)
    @name = name
    @reimbursement_calculator = reimbursement_calculator
    @project_list = project_list

    # find the first start date and last end date
    @first_start_date = earliest_start_date
    @last_end_date = latest_start_date

    # construct this dynamically: so in future can be configured per project_set.
    @day_cost_map ={
      Project::DAY_COST_TYPE[:travel] => {Project::CITY_COST_TYPE[:low] => 45.00, Project::CITY_COST_TYPE[:high] => 55.00},
      Project::DAY_COST_TYPE[:full]   => {Project::CITY_COST_TYPE[:low] => 75.00, Project::CITY_COST_TYPE[:high] => 85.00},
      Project::DAY_COST_TYPE[:none]   => {Project::CITY_COST_TYPE[:low] => 0.00,  Project::CITY_COST_TYPE[:high] => 0.00},
    }
  end

  def calculate_total_reimbursement
    @reimbursement_calculator.calculate_total_reimbursement(self, @first_start_date, @last_end_date)
  end

  # for a given day, create a list of maps containing the day_type and city_cost_type for each project in the set.
  # 
  def day_citycost_types(date)
    day_types = []
    @project_list.each do |proj|
      day_types << {day_type: proj.day_type(date), city_cost_type: proj.city_cost_type}
    end
    day_types
  end

  # returns the actual cost, in dollars, of a given day_city_cost_type
  def cost(day_city_cost_type)
    @day_cost_map[day_city_cost_type[:day_cost_type]][day_city_cost_type[:city_cost_type]]
  end

  private

  def earliest_start_date
    first_date = @project_list.first.start_date
    @project_list.each do |proj|
      first_date = proj.start_date if proj.start_date < first_date
    end
    first_date
  end

  def latest_start_date
    last_date = @project_list.first.end_date
    @project_list.each do |proj|
      last_date = proj.end_date if proj.end_date > last_date
    end
    last_date
  end

end