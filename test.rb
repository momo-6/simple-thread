require './standard_reimbursement_calculator'

# unit tests Project, ProjectSet, StandardReimbursementCalculator classes

def assert(boolean, message)
  if boolean
    puts "Success: " + message
  else
    puts ">>>> FAILED: " + message
  end
end

def create_test_project_set
  reimbursement_calc = StandardReimbursementCalculator.new()

  set2_proj1 = Project.new({name: "Project 1", city_cost_type: Project::CITY_COST_TYPE[:low],   start_date: "9/1/15", end_date: "9/1/15"})
  set2_proj2 = Project.new({name: "Project 2", city_cost_type: Project::CITY_COST_TYPE[:high],  start_date: "9/2/15", end_date: "9/6/15"})
  set2_proj3 = Project.new({name: "Project 3", city_cost_type: Project::CITY_COST_TYPE[:low],   start_date: "9/6/15", end_date: "9/8/15"})
  ProjectSet.new("Project set 2", reimbursement_calc, [set2_proj1, set2_proj2, set2_proj3])
end

# test project_set for first start date and last end date
def test_project_set_dates
  pset = create_test_project_set()

  assert(pset.first_start_date.day == 1, "test_project_set_dates: first start day should be 1")
  assert(pset.last_end_date.day == 8,    "test_project_set_dates: last end day should be 8")
end

def test_day_type
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

def test_day_citycost_types
  pset = create_test_project_set()

  # for readability, create some nicknames.
  travel  = Project::DAY_TYPE[:travel]
  full    = Project::DAY_TYPE[:full]
  before  = Project::DAY_TYPE[:before_travel]
  after   = Project::DAY_TYPE[:after_travel]
  outside = Project::DAY_TYPE[:outside]
  low     = Project::CITY_COST_TYPE[:low]
  high    = Project::CITY_COST_TYPE[:high]
  start   = pset.first_start_date

  s1a = pset.day_citycost_types(start - 2).map{|x| x[:day_type]}
  assert(s1a == [outside, outside,  outside], "test_day_citycost_types: start - 2 should be out,out,out for day types")
  s1b = pset.day_citycost_types(start - 2).map{|x| x[:city_cost_type]}
  assert(s1b == [low, high, low], "test_day_citycost_types: start -2 should be low,high,low for city cost types")

  s2a = pset.day_citycost_types(start + 1).map{|x| x[:day_type]}
  assert(s2a == [after,   travel,   outside], "test_day_citycost_types: start + 1 should be aft,trv,out for day types")
  s2b = pset.day_citycost_types(start + 1).map{|x| x[:city_cost_type]}
  assert(s2b == [low, high, low], "test_day_citycost_types: start + 1 should be low,high,low for city cost types")


  # assert(pset.day_citycost_types(start - 1) == [before,  outside,  outside], "test_day_citycost_types: start - 1 should be bef,out,out")
  # assert(pset.day_citycost_types(start    ) == [travel,  before,   outside], "test_day_citycost_types: start     should be trv,bef,out")
  # assert(pset.day_citycost_types(start + 2) == [outside, full,     outside], "test_day_citycost_types: start + 2 should be out,ful,out")
  # assert(pset.day_citycost_types(start + 3) == [outside, full,     outside], "test_day_citycost_types: start + 3 should be out,ful,out")
  # assert(pset.day_citycost_types(start + 4) == [outside, full,     before],  "test_day_citycost_types: start + 4 should be out,ful,bef")
  # assert(pset.day_citycost_types(start + 5) == [outside, travel,   travel],  "test_day_citycost_types: start + 5 should be out,trv,trv")
  # assert(pset.day_citycost_types(start + 6) == [outside, after,    full],    "test_day_citycost_types: start + 6 should be out,aft,ful")
  # assert(pset.day_citycost_types(start + 7) == [outside, outside,  travel],  "test_day_citycost_types: start + 7 should be out,out,trv")
  # assert(pset.day_citycost_types(start + 8) == [outside, outside,  after],   "test_day_citycost_types: start + 8 should be out,out,aft")
  # assert(pset.day_citycost_types(start + 9) == [outside, outside,  outside], "test_day_citycost_types: start + 9 should be out,out,out")
end

def test_compute_day_city_cost_type
  pset = create_test_project_set()
  rcalc = pset.reimbursement_calculator
  # create some nicknames for readability
  full = Project::DAY_COST_TYPE[:full]
  trav = Project::DAY_COST_TYPE[:travel]
  none = Project::DAY_COST_TYPE[:none]
  low  = Project::CITY_COST_TYPE[:low]
  high = Project::CITY_COST_TYPE[:high]
  # Project::CITY_COST_TYPE[:high]
  start   = pset.first_start_date

  assert(rcalc.compute_day_city_cost_type(pset.day_citycost_types(start - 2))[:day_cost_type] == none, 
    "test_compute_cost_day_type: start - 2 should be none for day cost type")
  assert(rcalc.compute_day_city_cost_type(pset.day_citycost_types(start - 2))[:city_cost_type] == low, 
    "test_compute_cost_day_type: start - 2 should be nil for city cost type")

  assert(rcalc.compute_day_city_cost_type(pset.day_citycost_types(start + 2))[:day_cost_type] == full, 
    "test_compute_cost_day_type: start + 2 should be full for day cost type")
  assert(rcalc.compute_day_city_cost_type(pset.day_citycost_types(start + 2))[:city_cost_type] == high, 
    "test_compute_cost_day_type: start + 2 should be high for city cost type")

  assert(rcalc.compute_day_city_cost_type(pset.day_citycost_types(start + 7))[:day_cost_type] == trav, 
    "test_compute_cost_day_type: start + 7 should be trav for day cost type")
  assert(rcalc.compute_day_city_cost_type(pset.day_citycost_types(start + 7))[:city_cost_type] == low, 
    "test_compute_cost_day_type: start + 7 should be low for city cost type")

  # assert(rcalc.compute_day_cost_type(pset.day_citycost_types(pset.first_start_date - 1)) == none, "test_compute_cost_day_type: start - 1 should be none")
  # assert(rcalc.compute_day_cost_type(pset.day_citycost_types(pset.first_start_date    )) == full, "test_compute_cost_day_type: start     should be full")
  # assert(rcalc.compute_day_cost_type(pset.day_citycost_types(pset.first_start_date + 1)) == full, "test_compute_cost_day_type: start + 1 should be full")
  # assert(rcalc.compute_day_cost_type(pset.day_citycost_types(pset.first_start_date + 2)) == full, "test_compute_cost_day_type: start + 2 should be full")
  # assert(rcalc.compute_day_cost_type(pset.day_citycost_types(pset.first_start_date + 3)) == full, "test_compute_cost_day_type: start + 3 should be full")
  # assert(rcalc.compute_day_cost_type(pset.day_citycost_types(pset.first_start_date + 4)) == full, "test_compute_cost_day_type: start + 4 should be full")
  # assert(rcalc.compute_day_cost_type(pset.day_citycost_types(pset.first_start_date + 5)) == full, "test_compute_cost_day_type: start + 5 should be full")
  # assert(rcalc.compute_day_cost_type(pset.day_citycost_types(pset.first_start_date + 6)) == full, "test_compute_cost_day_type: start + 6 should be full")
  # assert(rcalc.compute_day_cost_type(pset.day_citycost_types(pset.first_start_date + 7)) == trav, "test_compute_cost_day_type: start + 7 should be trav")
  # assert(rcalc.compute_day_cost_type(pset.day_citycost_types(pset.first_start_date + 8)) == none, "test_compute_cost_day_type: start + 8 should be none")
  # assert(rcalc.compute_day_cost_type(pset.day_citycost_types(pset.first_start_date + 9)) == none, "test_compute_cost_day_type: start + 9 should be none")
end

def test_calculate_total_reimbursement
  pset = create_test_project_set()
  total_cost = pset.reimbursement_calculator.calculate_total_reimbursement(pset, pset.first_start_date, pset.last_end_date)
  assert( total_cost == 620.0, "test_calculate_total_reimbursement: total cost should be 620.0")
end



################# run the tests
puts "------------------- running unit tests:"
puts "......testing project_set.first_start_date and project_set.last_end_date"
test_project_set_dates()
puts "......testing project.day_type"
test_day_type()
puts "......testing project_set.day_citycost_types"
test_day_citycost_types()
puts "......testing StandardReimbursementCalculator.compute_day_city_cost_type"
test_compute_day_city_cost_type()
puts "......testing StandardReimbursementCalculator.calculate_total_reimbursement"
test_calculate_total_reimbursement()



