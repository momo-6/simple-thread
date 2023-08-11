require './standard_reimbursement_calculator'


reimbursement_calc = StandardReimbursementCalculator.new()


# create the projects and sets
set1_proj1 = Project.new({name: "Project 1", city_cost_type: Project::CITY_COST_TYPE[:low],   start_date: "9/1/15", end_date: "9/3/15"})
set1 = ProjectSet.new("Project set 1", reimbursement_calc, [set1_proj1])

set2_proj1 = Project.new({name: "Project 1", city_cost_type: Project::CITY_COST_TYPE[:low],   start_date: "9/1/15", end_date: "9/1/15"})
set2_proj2 = Project.new({name: "Project 2", city_cost_type: Project::CITY_COST_TYPE[:high],  start_date: "9/2/15", end_date: "9/6/15"})
set2_proj3 = Project.new({name: "Project 3", city_cost_type: Project::CITY_COST_TYPE[:low],   start_date: "9/6/15", end_date: "9/8/15"})
set2 = ProjectSet.new("Project set 2", reimbursement_calc, [set2_proj1, set2_proj2, set2_proj3])

set3_proj1 = Project.new({name: "Project 1", city_cost_type: Project::CITY_COST_TYPE[:low],   start_date: "9/1/15", end_date: "9/3/15"})
set3_proj2 = Project.new({name: "Project 2", city_cost_type: Project::CITY_COST_TYPE[:high],  start_date: "9/5/15", end_date: "9/7/15"})
set3_proj3 = Project.new({name: "Project 3", city_cost_type: Project::CITY_COST_TYPE[:high],  start_date: "9/8/15", end_date: "9/8/15"})
set3 = ProjectSet.new("Project set 3", reimbursement_calc, [set3_proj1, set3_proj2, set3_proj3])

set4_proj1 = Project.new({name: "Project 1", city_cost_type: Project::CITY_COST_TYPE[:low],   start_date: "9/1/15", end_date: "9/1/15"})
set4_proj2 = Project.new({name: "Project 2", city_cost_type: Project::CITY_COST_TYPE[:low],   start_date: "9/1/15", end_date: "9/1/15"})
set4_proj3 = Project.new({name: "Project 3", city_cost_type: Project::CITY_COST_TYPE[:high],   start_date: "9/2/15", end_date: "9/2/15"})
set4_proj4 = Project.new({name: "Project 4", city_cost_type: Project::CITY_COST_TYPE[:high],   start_date: "9/2/15", end_date: "9/3/15"})
set4 = ProjectSet.new("Project set 4", reimbursement_calc, [set4_proj1, set4_proj2, set4_proj3, set4_proj4])

# calculate the reimbursements
set1_cost = set1.calculate_total_reimbursement()
set2_cost = set2.calculate_total_reimbursement()
set3_cost = set3.calculate_total_reimbursement()
set4_cost = set4.calculate_total_reimbursement()

# output reimbursements for each set, and for total
puts "------------- list of reimbersements for each set:"
puts "Set1 reimbursement: #{set1_cost}"
puts "Set2 reimbursement: #{set2_cost}"
puts "Set3 reimbursement: #{set3_cost}"
puts "Set4 reimbursement: #{set4_cost}"
puts "total reimbursement:  #{set1_cost + set2_cost + set3_cost + set4_cost}"




