#!/usr/local/bin/python3
def bubble_sort(items):
    if len(items) <= 1:
        return items
    for index in range(len(items)-1,0,-1):
        flag = False
        for sub_index in range(index):
            if items[sub_index] > items[sub_index + 1]:
                items[sub_index],items[sub_index + 1] = items[sub_index + 1], items[sub_index]
                flag = True
        if flag == False:
            break
    return items


testlist = [17, 23, 20, 14, 12, 25, 1, 20, 81, 14, 11, 12]
print('Before selection sort: {}'.format(testlist))
print('After selection sort:  {}'.format(bubble_sort(testlist)))
