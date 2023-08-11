require './project'


# This classes role is to hold the list of projects, any data associated with that list ( for now just name )
#  and to hold the strategy for calculating the total reimbursement, which can be swapped out in the future for another
#  way of calculating it.
class ProjectSet
  attr_reader :first_start_date, :last_end_date

  def initialize(name, reimbursement_calculator, project_list)
    @name = name
    @reimbursement_calculator = reimbursement_calculator
    @project_list = project_list

    # find the first start date and last end date
    @first_start_date = earliest_start_date
    @last_end_date = latest_start_date
  end

  def calculate_total_reimbursement
    @reimbursement_calculator.calculate_total_reimbursement(@project_list, @first_start_date, @last_end_date)
  end

  private

  # todo: we can refactor these to something simpler later
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