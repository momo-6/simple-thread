require './standard_reimbursement_calculator'

# unit tests Project, ProjectSet, StandardReimbursementCalculator classes

def assert(boolean, message)
  if boolean
    puts "Succes: " + message
  else
    puts "FAILED: " + message
  end
end

# test project_set for first start date and last end date
def test_project_set_dates
  reimbursement_calc = StandardReimbursementCalculator.new()

  set2_proj1 = Project.new({name: "Project 1", city_cost_type: Project::CITY_COST_TYPE[:low],   start_date: "9/1/15", end_date: "9/1/15"})
  set2_proj2 = Project.new({name: "Project 2", city_cost_type: Project::CITY_COST_TYPE[:high],  start_date: "9/2/15", end_date: "9/6/15"})
  set2_proj3 = Project.new({name: "Project 3", city_cost_type: Project::CITY_COST_TYPE[:low],   start_date: "9/6/15", end_date: "9/8/15"})
  set2 = ProjectSet.new("Project set 2", reimbursement_calc, [set2_proj1, set2_proj2, set2_proj3])

  assert(set2.first_start_date.day == 1, "test_project_set_dates: first start day should be 1")
  assert(set2.last_end_date.day == 8,    "test_project_set_dates: last end day should be 8")
end

def test_project_day_type
  set2_proj2 = Project.new({name: "Project 2", city_cost_type: Project::CITY_COST_TYPE[:high],  start_date: "9/10/15", end_date: "9/15/15"})
  test_date  = DateTime.strptime( "9/8/15", "%m/%d/%Y")

  assert(set2_proj2.day_type(test_date)     == Project::DAY_TYPE[:outside],       "test_project_day_type: #{test_date    } should be outside")
  assert(set2_proj2.day_type(test_date + 1) == Project::DAY_TYPE[:before_travel], "test_project_day_type: #{test_date + 1} should be before_travel")
  assert(set2_proj2.day_type(test_date + 2) == Project::DAY_TYPE[:travel],        "test_project_day_type: #{test_date + 2} should be travel")

  assert(set2_proj2.day_type(test_date + 3) == Project::DAY_TYPE[:full],          "test_project_day_type: #{test_date + 3} should be full")

  assert(set2_proj2.day_type(test_date + 7) == Project::DAY_TYPE[:travel],        "test_project_day_type: #{test_date + 7} should be travel")
  assert(set2_proj2.day_type(test_date + 8) == Project::DAY_TYPE[:after_travel],  "test_project_day_type: #{test_date + 8} should be after_travel")
  assert(set2_proj2.day_type(test_date + 9) == Project::DAY_TYPE[:outside],       "test_project_day_type: #{test_date + 9} should be outside")
end



################# run the tests
puts "------------------- running unit tests:"
test_project_set_dates()
puts ""
test_project_day_type()