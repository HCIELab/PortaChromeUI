import numpy as np
from scipy import optimize

FULL_DEACTIVATION_TIME = [
  [161.7,150.45,34.17],
  [54.06,96.65,50.49],
  [25.76,17.34,183.6]
]

# solve Ax = b
# get the closest value that it gives while
# keeping x non-negative
def linear_programming_solve(A, b):
	'''
	The linear progression is like this: 
		min(y0 + y1 + y2)
		when 
			y0 >= (Ax-b)[0]
			y0 >= -(Ax-b)[0]
			y1 >= (Ax-b)[1]
			y1 >= -(Ax-b)[1]
			y2 >= (Ax-b)[2]
			y3 >= -(Ax-b)[2]
	We then convert y0, y1, y2 to x3, x4, x5, respectively
	and then solve to fit the scipy API
	here: https://docs.scipy.org/doc/scipy/reference/generated/scipy.optimize.linprog.html
	'''
	c = [0,0,0,1,1,1]
	A_ub = []
	for i in range(6):
		row = []
		for j in range(3):
			if i % 2 == 0:
				row.append(A[i//2][j])
			else:
				row.append(-A[i//2][j])
		for j in range(3,6):
			row.append(0)

		row[i//2 + 3] = -1
		A_ub.append(row)
	b_ub = [b[0], -b[0], b[1], -b[1], b[2], -b[2]]
	bounds = [(0, None), (0, None), (0, None), (None, None), (None, None), (None, None)]

	results = optimize.linprog(c=c, A_ub=A_ub, b_ub=b_ub, bounds=bounds)
	return({
    "x": [results.x[0], results.x[1], results.x[2]],
    "error": results.fun 
    })





deactivation_speed = []
for i in range(3):
	row = []
	for j in range(3):
		row.append(1 / FULL_DEACTIVATION_TIME [i][j])
	deactivation_speed.append(row)
deactivation_speed = np.array(deactivation_speed)


time = np.array([1,6,3])
color_to_deactivate = np.matmul(deactivation_speed, time)
# color_to_deactivate = [np.dot(deactivation_speed[0], [1,1,1]), 0, 0]
print(color_to_deactivate)


# allow negative to find the best value
# absolute_time_to_deactivate = np.matmul(np.linalg.inv(deactivation_speed), color_to_deactivate )
# print("actual: ", absolute_time_to_deactivate)

# print("A: ", deactivation_speed)



results = linear_programming_solve(deactivation_speed,color_to_deactivate)
print("RESULT:", results["x"])
print(results["error"])

error = np.matmul(deactivation_speed, np.array(results["x"])) - color_to_deactivate
print(error)

# times = [100,100,100]

# for iter in range(200):
# 	intermediate_result = np.matmul(deactivation_speed, times)
# 	# print(len(intermediate_result))
# 	loss =  intermediate_result - vector_to_deactivate
# 	cost = np.sum(loss ** 2) / (2 * len(loss))
# 	print(cost)
# 	gradient = loss
# 	times = times + gradient * 0.1
# print(times)

# print(np.matmul(A,times))

# def calculateCost(A,x,b):
# 	return b - np.matmul(A,x)

# while previous_step_size > precision and iters < max_iters:
#     prev_x = cur_x #Store current x value in prev_x
#     cur_x = cur_x - rate * calculateCost(A,b,cur_x) #Grad descent
#     previous_step_size = abs(cur_x - prev_x) #Change in x
#     iters = iters+1 #iteration count
#     print("Iteration",iters,"\nX value is",cur_x) #Print iterations

