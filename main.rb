

reimbursement_calc = StandardReimbursementCalculator.new()


# create the projects and sets
set1_proj1 = Project.new({name: "Project 1", city_cost_type: Project.CITY_COST_TYPE[:low],   start_date: "9/1/15", end_date: "9/3/15"})
set1 = ProjectSet.new("Project set 1", reimbursement_calc, [set1_proj1])

set2_proj1 = Project.new({name: "Project 1", city_cost_type: Project.CITY_COST_TYPE[:low],   start_date: "9/1/15", end_date: "9/1/15"})
set2_proj2 = Project.new({name: "Project 2", city_cost_type: Project.CITY_COST_TYPE[:high],  start_date: "9/2/15", end_date: "9/6/15"})
set2_proj3 = Project.new({name: "Project 3", city_cost_type: Project.CITY_COST_TYPE[:low],   start_date: "9/6/15", end_date: "9/8/15"})
set2 = ProjectSet.new("Project set 2", reimbursement_calc, [set2_proj1, set2_proj2, set2_proj3])


# calculate the reimbursements
set1_cost = set1.calculate_total_reimbursement()

# output reimbursements for each set, and for total
puts("Set1 reimbursement: " + set1_cost)