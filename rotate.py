#!/bin/env python

import numpy as np

# import matplotlib.pyplot as plt

a = 3
a1 = np.array([a/2, a*np.sqrt(3)/2])
a2 = np.array([a, 0])

m = 3
n = 1

if m < n:
    print("m must bigger than n")
    exit(1)

vaccu = 20
d = 3
layer1_hight = 1
layer2_hight = 1

# dis = 6.65
# d = dis - (layer1_hight + layer2_hight)/2

layer1 = {"C": [np.array([0, 0, vaccu/2+d+layer2_hight+layer1_hight/2]),
                np.array([1/3, 1/3, vaccu/2+d+layer2_hight+layer1_hight/2])
                ]}

layer2 = {"C": [np.array([0, 0, vaccu/2+layer2_hight/2]),
                np.array([1/3, 1/3, vaccu/2+layer2_hight/2])]}


N = max(m, n)**2

l0 = np.array([0, 0])
l1 = m*a1 + n*a2
l2 = (m+n + m)*a1 + (n-m)*a2
l3 = n*a1 + m*(-a2 + a1)


# 检查是否在超胞内
def check_points(points, vertices):

    def point_in_quadrilateral(point, vertices):
        point = point[:2]

        # 检查点是否在四边形内
        vectors = [vertices[(i + 1) % 4] - vertices[i] for i in range(4)]
        test_vectors = [point - vertices[i] for i in range(4)]

        cross_products = [np.cross(vectors[i], test_vectors[i])
                          for i in range(4)]

        if ((all(cross_product >= 0 for cross_product in cross_products[:2]) and
             all(cross_product > 0 for cross_product in cross_products[2:]))
            or
            (all(cross_product <= 0 for cross_product in cross_products[:2]) and
             all(cross_product < 0 for cross_product in cross_products[2:]))):
            return True
        else:
            return False

    # 筛选出在四边形内部的点
    filtered_points = np.array(
        [point for point in points if point_in_quadrilateral(point, vertices)])

    return filtered_points


offset = np.array([0.00000001, 0.00000001])
layer1_res = {}

for atom in layer1:
    points = []

    for position in layer1[atom]:
        atom_pos = position[0]*a1 + position[1] * a2
        for row in range(-N, N):
            for col in range(-N, N):
                point = [*(row*a1+col*a2+atom_pos), position[2]]
                points.append(point)
                pass
            pass
        pass
    layer1_res[atom] = check_points(points, [l0, l1, l2, l3])
    pass


cos = a1.dot(a2)/a**2
costheta = 1/2 * (m**2 + n**2 + (2+4*cos)*m*n) / (m**2 + n**2 + 2*m*n*cos)
theta = np.arccos(costheta)
sintheta = np.sin(theta)

'''
costheta = 1
sintheta = 0
'''


layer2_res = {}

for atom in layer2:
    points = []

    for position in layer2[atom]:
        atom_pos = position[0]*a1 + position[1]*a2 + offset
        for row in range(-N, N):
            for col in range(-N, N):
                point = row*a1 + col*a2 + atom_pos
                points.append([point[0]*costheta - point[1]*sintheta,
                               point[1]*costheta + point[0]*sintheta,
                               position[2]])
                pass
            pass
        pass
    layer2_res[atom] = check_points(points, [l0, l1, l2, l3])
    pass

final_res = {}

for atom1, pos1 in layer1_res.items():
    for atom2, pos2 in layer2_res.items():
        if atom1 == atom2:
            layer1_res[atom1] = np.vstack((pos1, pos2))
            layer2_res[atom1] = np.vstack((pos1, pos2))
            final_res[atom1] = np.vstack((pos1, pos2))
        else:
            final_res[atom1] = layer1_res[atom1]
            final_res[atom2] = layer2_res[atom2]
            pass
        pass
    pass

f = open('rotate.vasp', 'w')

print("rotato super cell", file=f)
print("   1.00000000000000", file=f)
print("    {:17.12f}{:17.12f}{:17.12f}".format(*l1, 0), file=f)
print("    {:17.12f}{:17.12f}{:17.12f}".format(*l3, 0), file=f)
print("    {:17.12f}{:17.12f}{:17.12f}".format(
    0, 0, vaccu+layer1_hight+layer2_hight+d), file=f)

print(*final_res.keys(), file=f)
print(*[len(value) for value in final_res.values()], file=f)
print("Cartesian", file=f)

for atom_name, atom_positions in final_res.items():
    for atom_position in atom_positions:
        print("  {:17.12f}{:17.12f}{:17.12f}".format(*atom_position), file=f)
        pass
    pass
