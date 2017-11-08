#!/usr/local/bin/python3
def selection_sort(L):
    length = len(L)
    for i in range(length-1):
        min_index = i
        for j in range(i+1, length):
            if L[min_index] > L[j]:
                min_index = j
        if min_index != i:
            L[min_index], L[i] = L[i], L[min_index]
    return L

testlist = [17, 23, 20, 14, 12, 25, 1, 20, 81, 14, 11, 12]
print('Before selection sort: {}'.format(testlist))
print('After selection sort:  {}'.format(selection_sort(testlist)))
