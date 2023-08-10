
# This classes role is to hold the list of projects, any data associated with that list ( for now just name )
#  and to hold the strategy for calculating the total reimbursement, which can be swapped out in the future for another
#  way of calculating it.
class ProjectSet

  def initialize(name, reimbursement_calculator project_list)
    @name = name
    @reimbursement_calculator = reimbursement_calculator
    @project_list = project_list

    # find the first start date and last end date
    @first_start_date = 
    @last_end_date = 
  end

  def calculate_total_reimbursement
    @reimbursement_calculator.calculate_total_reimbursement(@project_list, @first_start_date, @last_end_date)
  end
end